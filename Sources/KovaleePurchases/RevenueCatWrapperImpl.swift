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

    func handleWebRedemptionURL(_ url: URL) async throws -> Bool {
        if let webPurchaseRedemption = url.asWebPurchaseRedemption,
           Purchases.isConfigured {
               let result = await Purchases.shared.redeemWebPurchase(webPurchaseRedemption)
               switch result {
               case let .success(infos):
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
        guard let webPurchaseRedemption = url.asWebPurchaseRedemption, Purchases.isConfigured else {
            return false
        }
        return true
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

        return KPurchaseResultData(
            transaction: KStoreTransaction(transaction: purchaseResult.transaction),
            customerInfo: KCustomerInfo(info: purchaseResult.customerInfo),
            userCancelled: purchaseResult.userCancelled
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
            userCancelled: purchaseResult.userCancelled
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
}

extension RevenueCatWrapperImpl: @unchecked Sendable {}

extension RevenueCatWrapperImpl: RevenueCat.PurchasesDelegate {
    func purchases(_: Purchases, receivedUpdated customerInfo: RevenueCat.CustomerInfo) {
        KLogger.debug("🛍️ did receive update \(customerInfo)")

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
}
