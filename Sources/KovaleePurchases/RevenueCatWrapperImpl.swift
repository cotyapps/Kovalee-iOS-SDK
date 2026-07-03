import Foundation
import KovaleeFramework
import KovaleeRemoteConfig
import KovaleeSDK
import RevenueCat

public enum WebPurchaseRedemptionError: Error {
    case newLinkSentToEmail(obfuscatedEmail: String)
    case invalidToken
    case otherError(String)
    case purchaseBelongsToOtherUser
}

final class RevenueCatWrapperImpl: NSObject, PurchaseManager, Manager {

    func handleWebUser(withId userId: String) async throws -> Bool {
        _ = try await Kovalee.setRevenueCatUserId(userId: userId)
        Kovalee.setAmplitudeUserId(userId: userId)

        let isPremium = try await Kovalee.isUserPremium()
        if isPremium {
            Kovalee.setUserProperty(key: "web_premium", value: "true")
        }
        return isPremium
    }
    
    func isRCWebPurchaseRedemptionURL(_ url: URL) -> Bool {
        guard let _ = url.asWebPurchaseRedemption, Purchases.isConfigured else {
            return false
        }
        return true
    }

    func handleWebRedemptionURL(_ url: URL) async throws -> Bool {
        if let webPurchaseRedemption = url.asWebPurchaseRedemption,
           Purchases.isConfigured {
               let result = await Purchases.shared.redeemWebPurchase(webPurchaseRedemption)
               switch result {
               case let .success(customerInfo):
                   KLogger.debug("🛍️ Web purchase redeemed successfully")
                   KLogger.debug("🛍️ appUserID: \(Purchases.shared.appUserID)")
                   KLogger.debug("🛍️ originalAppUserId: \(customerInfo.originalAppUserId)")
                   KLogger.debug("🛍️ firstSeen: \(customerInfo.firstSeen)")
                   KLogger.debug("🛍️ activeSubscriptions: \(customerInfo.activeSubscriptions)")
                   KLogger.debug("🛍️ activeEntitlements: \(customerInfo.entitlements.active.keys.joined(separator: ", "))")
                   KLogger.debug("🛍️ allPurchasedProductIdentifiers: \(customerInfo.allPurchasedProductIdentifiers)")
                   KLogger.debug("🛍️ latestExpirationDate: \(String(describing: customerInfo.latestExpirationDate))")
                   KLogger.debug("🛍️ managementURL: \(String(describing: customerInfo.managementURL))")
                   KLogger.debug("🛍️ nonSubscriptions: \(customerInfo.nonSubscriptions)")

                   let isPremium = try await Kovalee.isUserPremium()
                   if isPremium {
                       Kovalee.setUserProperty(key: "web_premium", value: "true")
                   }
                   return isPremium
               case let .error(error):
                   throw WebPurchaseRedemptionError.otherError(error.localizedDescription)
               case .invalidToken:
                   throw WebPurchaseRedemptionError.invalidToken
               case .purchaseBelongsToOtherUser:
                   throw WebPurchaseRedemptionError.purchaseBelongsToOtherUser
               case let .expired(obfuscatedEmail):
                   throw WebPurchaseRedemptionError.newLinkSentToEmail(obfuscatedEmail: obfuscatedEmail)
               }
        } else {
            return false
        }
    }
    init(withKeys keys: KovaleeKeys.RevenueCat) {
        super.init()

        KLogger.debug("initializing RevenueCat")

        Purchases.logLevel = KLogger.logLevel.revenueCatLogLevel()
        Purchases.configure(
            with: RevenueCat.Configuration
                .builder(withAPIKey: keys.sdkId)
                .with(
                    purchasesAreCompletedBy: keys.observerMode ? .myApp : .revenueCat,
                    storeKitVersion: StoreKitVersion.storeKit2
                )
                .build()
        )
        Purchases.shared.delegate = self

        // Set $firebaseAppInstanceId as soon as Firebase is configured (signalled by
        // KovaleeRemoteConfig), so it's pending on the subscriber before the user can
        // reach a paywall — RevenueCat then includes it with the purchase receipt.
        // The PurchasesDelegate callback keeps it in sync afterwards as a backstop.
        firebaseConfiguredObserver = NotificationCenter.default.addObserver(
            forName: .kovaleeFirebaseConfigured,
            object: nil,
            queue: nil
        ) { _ in
            FirebaseRevenueCatLink.sync()
        }
    }

    func logout() async throws -> AbstractCustomerInfo {
        let customerInfo = try await Purchases.shared.logOut()
        return KCustomerInfo(info: customerInfo)
    }

    func setUserId(userId: String) async throws -> (AbstractCustomerInfo, created: Bool) {
        let result = try await Purchases.shared.logIn(userId)
        return (KCustomerInfo(info: result.customerInfo), result.created)
    }

    func setEmail(email: String) {
        Purchases.shared.attribution.setEmail(email)
    }

    func revenueCatUserId() -> String {
        Purchases.shared.appUserID
    }

    func cancellableStripeSubscriptionId() async throws -> String? {
        let infos = try await Purchases.shared.customerInfo()
        let activeSubscriptions = infos.activeSubscriptions
            .compactMap({ infos.subscriptionsByProductIdentifier[$0] })

        return activeSubscriptions
             .filter { $0.store == .stripe}
             .filter { $0.storeTransactionId != nil }
             .first { $0.willRenew == true }?
             .storeTransactionId
    }

    func fetchOfferings() async throws -> AbstractOfferings? {
        let rcOfferings = try await Purchases.shared.offerings()

        let offerings = KOfferings(rcOfferings)
        offerings.all.keys.forEach { KLogger.debug("🛍️ Fetched offerings \($0)") }

        return offerings
    }

    func fetchCurrentOffering() async throws -> AbstractOffering? {
        KLogger.debug("🛍️ Fetching current offering...")

        let offerings = try await Purchases.shared.offerings()
        let abTestValue = await Kovalee.abTestValue()

        let variantOffering = offerings.all.values.first { offering in
            guard let variant = offering.metadata["ab_test_version"] as? Int else {
                return false
            }

            return abTestValue == "\(variant)"
        }

        if let variantOffering {
            KLogger.debug("🛍️ Fetched current offering \(variantOffering)")
            return KOffering(offering: variantOffering)
        } else if let current = offerings.current {
            KLogger.debug("🛍️ Fetched current offering \(current)")
            return KOffering(offering: current)
        } else {
            return nil
        }
    }

    func checkTrialOrIntroDiscountEligibility(productIdentifiers: [String]) async -> [String: Int] {
        await Purchases.shared
            .checkTrialOrIntroDiscountEligibility(productIdentifiers: productIdentifiers)
            .mapValues { $0.status.rawValue }
    }

    func restorePurchases() async throws -> AbstractCustomerInfo {
        KLogger.debug("🛍️ Restoring purchase...")

        let rcCustomerInfo = try await Purchases.shared.restorePurchases()
        KLogger.debug("🛍️ Purchase restored with customer info: \(rcCustomerInfo)")

        return KCustomerInfo(info: rcCustomerInfo)
    }

    func purchase(package: AbstractPackage) async throws -> AbstractPurchaseResultData {
        guard let rcPackage = package.rcPackage as? RevenueCat.Package else {
            throw KovaleePurchasesError.noRCPackageIdentified
        }
        let purchaseResult = try await Purchases.shared.purchase(package: rcPackage)
        KLogger.debug("🛍️ Purchase \(purchaseResult)")

        let product = rcPackage.storeProduct
        return KPurchaseResultData(
            transaction: KStoreTransaction(transaction: purchaseResult.transaction),
            customerInfo: KCustomerInfo(info: purchaseResult.customerInfo),
            userCancelled: purchaseResult.userCancelled,
            productId: product.productIdentifier,
            priceDecimal: product.price,
            currencyCode: product.currencyCode,
            hasFreeTrial: transactionStartedFreeTrial(purchaseResult.transaction, product: product),
            subscriptionPeriodUnit: product.subscriptionPeriod?.kPurchasePeriodUnit
        )
    }

    func purchaseProduct(withId productId: String) async throws -> AbstractPurchaseResultData {
        guard let product = await Purchases.shared.products([productId]).first else {
            throw KovaleePurchasesError.noProductWithSpecifiedId
        }

        let purchaseResult = try await Purchases.shared.purchase(product: product)
        KLogger.debug("🛍️ Purchase \(purchaseResult)")

        return KPurchaseResultData(
            transaction: KStoreTransaction(transaction: purchaseResult.transaction),
            customerInfo: KCustomerInfo(info: purchaseResult.customerInfo),
            userCancelled: purchaseResult.userCancelled,
            productId: product.productIdentifier,
            priceDecimal: product.price,
            currencyCode: product.currencyCode,
            hasFreeTrial: transactionStartedFreeTrial(purchaseResult.transaction, product: product),
            subscriptionPeriodUnit: product.subscriptionPeriod?.kPurchasePeriodUnit
        )
    }

    func syncPurchase() async throws -> AbstractCustomerInfo {
        let info = try await Purchases.shared.syncPurchases()
        return KCustomerInfo(info: info)
    }

    func customerInfo() async throws -> AbstractCustomerInfo {
        let info = try await Purchases.shared.customerInfo()
        return KCustomerInfo(info: info)
    }

    func setAttribution(adid: String) {
        Purchases.shared.attribution.setAdjustID(adid)
    }

    func setAmplitudeUserId(userId: String) {
        Purchases.shared.attribution.setAttributes(["$amplitudeUserId": userId])
    }

    func setPurchaseDelegate(_ delegate: KovaleeFramework.KovaleePurchasesDelegate) {
        self.delegate = delegate
    }

    private var delegate: KovaleeFramework.KovaleePurchasesDelegate?
    private var firebaseConfiguredObserver: NSObjectProtocol?

    deinit {
        if let firebaseConfiguredObserver {
            NotificationCenter.default.removeObserver(firebaseConfiguredObserver)
        }
    }
}

extension RevenueCatWrapperImpl: @unchecked Sendable {}

/// Bridges Firebase's analytics identity into RevenueCat.
///
/// Implements step 2 of RevenueCat's Firebase integration — "Set Firebase user
/// identity in RevenueCat" — by mirroring Firebase's app-instance ID into the
/// reserved `$firebaseAppInstanceId` subscriber attribute, so RevenueCat can
/// deliver subscription events back to the matching Firebase user.
/// https://www.revenuecat.com/docs/integrations/third-party-integrations/firebase-integration#2-set-firebase-user-identity-in-revenuecat
///
/// Firebase is configured during ``Kovalee/initialize(configuration:)`` *after*
/// the purchase manager is built, so the ID isn't readable at init time. Instead
/// it's forwarded — idempotently — from the `PurchasesDelegate` CustomerInfo
/// callback, which fires at launch and on every change regardless of how the host
/// app drives RevenueCat. Re-setting the attribute is cheap and overwrites the
/// prior value, so calling this repeatedly is safe.
enum FirebaseRevenueCatLink {
    static func sync() {
        guard Purchases.isConfigured,
              let appInstanceID = Kovalee.firebaseAppInstanceID() else {
            return
        }
        Purchases.shared.attribution.setFirebaseAppInstanceID(appInstanceID)
        KLogger.debug("🛍️ Linked Firebase appInstanceID to RevenueCat ($firebaseAppInstanceId)")
    }
}

extension RevenueCatWrapperImpl: RevenueCat.PurchasesDelegate {
    func purchases(_: Purchases, receivedUpdated customerInfo: RevenueCat.CustomerInfo) {
        KLogger.debug("🛍️ did receive update \(customerInfo)")

        // Keep RevenueCat's $firebaseAppInstanceId attribute in sync. This delegate
        // fires at launch (initial CustomerInfo) and on every change — regardless of
        // whether the host app drives RevenueCat through the Kovalee wrapper or
        // Purchases.shared directly — so the attribute is set before RevenueCat sends
        // its Measurement Protocol events to Firebase/GA4.
        FirebaseRevenueCatLink.sync()

        delegate?.didReceiveUpdate(KCustomerInfo(info: customerInfo))
    }

    func purchases(
        _: Purchases,
        readyForPromotedProduct product: StoreProduct,
        purchase startPurchase: @escaping StartPurchaseBlock
    ) {
        KLogger.debug("🛍️ ready for Promoted Product \(product)")

        startPurchase { transaction, customerInfo, error, _ in
            let storeTransaction = KStoreTransaction(transaction: transaction)
            let info = customerInfo.map { KCustomerInfo(info: $0) }

            self.delegate?.readyForPromotedProduct(
                KStoreProduct(product),
                purchaseBlock: (storeTransaction, info, error)
            )
        }
    }
}

public enum KovaleePurchasesError: Error {
    case noProductWithSpecifiedId
    case noRCPackageIdentified
}

extension KovaleeFramework.LogLevel {
    func revenueCatLogLevel() -> RevenueCat.LogLevel {
        RevenueCat.LogLevel(rawValue: rawValue) ?? .debug
    }
}

/// Whether *this* purchase actually started a free trial — transaction-level truth.
///
/// `product.introductoryDiscount?.paymentMode == .freeTrial` only says the product
/// *offers* a trial; a lapsed (intro-ineligible) re-subscriber buying the same product
/// pays full price immediately. Reporting that as a StartTrial would feed fabricated
/// trial signals to the ad platforms, so when the StoreKit 2 transaction is available
/// we require that it really redeemed an introductory offer. Without a transaction
/// (SK1 path, observer edges) we fall back to the product-level check.
func transactionStartedFreeTrial(
    _ transaction: RevenueCat.StoreTransaction?,
    product: RevenueCat.StoreProduct
) -> Bool {
    guard product.introductoryDiscount?.paymentMode == .freeTrial else { return false }
    guard let sk2 = transaction?.sk2Transaction else { return true }
    if #available(iOS 17.2, macOS 14.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *) {
        return sk2.offer?.type == .introductory
    } else {
        return sk2.offerType == .introductory
    }
}

extension RevenueCat.SubscriptionPeriod {
    func getDuration() -> Int {
        switch unit {
        case .day:
            return 1
        case .month:
            return 30
        case .week:
            return 7
        case .year:
            return 365
        }
    }

    var kPurchasePeriodUnit: KPurchasePeriodUnit {
        switch unit {
        case .day:
            return .day
        case .week:
            return .week
        case .month:
            return .month
        case .year:
            return .year
        }
    }
}

public extension Kovalee {
    /// Fires purchase-conversion events (Facebook + TikTok + Firebase revenue) for a
    /// completed RevenueCat purchase, deriving value / currency / period from the
    /// package's `StoreProduct` — and, when the `StoreTransaction` is provided, the
    /// transaction id (GA4 dedup) and whether *this* purchase really started a free
    /// trial (an intro-ineligible re-subscriber pays immediately even on a
    /// trial-bearing product).
    ///
    /// Call this from remote-paywall completion handlers (e.g. RevenueCatUI's
    /// two-argument `onPurchaseCompleted { transaction, _ in ... }`) that do NOT flow
    /// through `Kovalee.purchase(...)`. Native `Kovalee.purchase(...)` already fires
    /// conversions internally, so a given purchase must reach this through exactly one
    /// path — never both. Consent-gated internally.
    static func trackSubscriptionConversion(package: Package, transaction: RevenueCat.StoreTransaction? = nil) {
        let product = package.storeProduct
        guard let currency = product.currencyCode else {
            KLogger.warn("Purchase conversion dropped: product \(product.productIdentifier) has no currency code")
            return
        }
        trackSubscriptionConversion(
            productId: product.productIdentifier,
            value: NSDecimalNumber(decimal: product.price).doubleValue,
            currency: currency,
            periodUnit: product.subscriptionPeriod?.kPurchasePeriodUnit,
            hasFreeTrial: transactionStartedFreeTrial(transaction, product: product),
            transactionId: transaction?.transactionIdentifier
        )
    }
}
