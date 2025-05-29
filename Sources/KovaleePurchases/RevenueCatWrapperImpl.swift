import Foundation
import KovaleeFramework
import KovaleeRemoteConfig
import KovaleeSDK
import RevenueCat

final class RevenueCatWrapperImpl: NSObject, PurchaseManager, Manager {
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

    func asyncPurchase(withId productId: String) {
        Task {
            _ = try? await Kovalee.purchaseSubscription(
                withId: productId,
                fromSource: "external"
            )
        }
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
        readyForPromotedProduct _: StoreProduct,
        purchase startPurchase: @escaping StartPurchaseBlock
    ) {
        startPurchase { _, customerInfo, _, _ in
            customerInfo?.entitlements.all.values
                .filter { $0.isActive == true }
                .forEach { self.asyncPurchase(withId: $0.productIdentifier) }
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
