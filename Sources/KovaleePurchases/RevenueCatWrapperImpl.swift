import Foundation
import KovaleeFramework
import RevenueCat

class RevenueCatWrapperImpl: NSObject, PurchaseManager {
	init(withKeys keys: KovaleeKeys.RevenueCat) {
        super.init()

		KLogger.debug("initializing RevenueCat")

        Purchases.logLevel = KLogger.logLevel.revenueCatLogLevel()
        Purchases.configure(
            with: RevenueCat.Configuration
				.builder(withAPIKey: keys.sdkId)
				.with(observerMode: keys.observerMode)
				.build()
        )
    }

    func setUserId(userId: String) {
        Task {
            try? await Purchases.shared.logIn(userId)
        }
    }

    func fetchOfferings() async throws -> AbstractOfferings? {
        let rcOfferings = try await Purchases.shared.offerings()

        let offerings = Offerings(rcOfferings)
        offerings.all.keys.forEach { KLogger.debug("🛍️ Fetched offerings \($0)") }

        return offerings
    }

    func fetchCurrentOffering() async throws -> AbstractOffering? {
		KLogger.debug("🛍️ Fetching current offering...")
        let rcOfferings = try await Purchases.shared.offerings()
        guard let current = rcOfferings.current else {
            return nil
        }
		KLogger.debug("🛍️ Fetched current offering \(current)")
        return Offering(offering: current)
    }

    func restorePurchases() async throws -> AbstractCustomerInfo? {
		KLogger.debug("🛍️ Restoring purchase...")

        let rcCustomerInfo = try await Purchases.shared.restorePurchases()
        return CustomerInfo(info: rcCustomerInfo)
    }

    func purchase(package: AbstractPackage) async throws -> AbstractPurchaseResultData {
		let purchaseResult = try await Purchases.shared.purchase(package: package.rcPackage as! RevenueCat.Package)
        KLogger.debug("🛍️ Purchase \(purchaseResult)")

        return PurchaseResultData(
            transaction: StoreTransaction(transaction: purchaseResult.transaction),
            customerInfo: CustomerInfo(info: purchaseResult.customerInfo),
            userCancelled: purchaseResult.userCancelled
        )
    }

    func customerInfo() async throws -> AbstractCustomerInfo {
        let info = try await Purchases.shared.customerInfo()
        return CustomerInfo(info: info)
    }

    func setAttribution(adid: String) {
        Purchases.shared.attribution.setAdjustID(adid)
    }

    func setAmplitudeUserId(userId: String) {
        Purchases.shared.attribution.setAttributes(["$amplitudeUserId": userId])
    }
}

extension KovaleeFramework.LogLevel {
    func revenueCatLogLevel() -> RevenueCat.LogLevel {
        RevenueCat.LogLevel(rawValue: self.rawValue) ?? .debug
    }
}

extension RevenueCat.SubscriptionPeriod {
    func getDuration() -> Int {
        switch self.unit {
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
