#if os(watchOS)
import Foundation
import KovaleeFramework

/// watchOS builds link only ``KovaleeSDK`` (analytics). The attribution
/// (Adjust), purchases (RevenueCat) and remote-config (Firebase) modules are
/// not part of an analytics-only watch target — Adjust doesn't even ship a
/// watchOS slice — yet ``KovaleeManager`` requires all three managers to be
/// non-nil. These no-op implementations satisfy that contract so
/// ``Kovalee/initialize(configuration:)`` succeeds with just the event tracker.
///
/// Any call that would need a real backing service throws
/// ``NoopManagerError/unavailableOnWatchOS`` rather than returning fake data.

enum NoopManagerError: Error {
    /// The capability is not available in an analytics-only watchOS build.
    case unavailableOnWatchOS
}

struct NoopAttributionManager: AttributionManager {
    func getAttributionAdid() async -> String? { nil }

    func sendConversionValue(value _: Int, coarseValue _: String?, completion: @escaping ((any Error)?) -> Void) {
        completion(nil)
    }

    func setDataCollectionEnabled(_: Bool) {}

    func setAttributionDelegate(_: any KovaleeAttributionDelegate) {}
}

struct NoopRemoteConfigurationManager: RemoteConfigurationManager {
    func setFetchTimeout(_: Double) {}

    func fetchAndActivateRemoteConfig() async {}

    func setDefaultValues(_: [String: Any]) {}

    func value(forKey _: String) async throws -> Data {
        throw NoopManagerError.unavailableOnWatchOS
    }

    func setDataCollectionEnabled(_: Bool) {}

    func setAdvertisingConsentGranted(_: Bool) {}
}

struct NoopPurchaseManager: PurchaseManager {
    func revenueCatUserId() -> String { "" }

    func setUserId(userId _: String) async throws -> (any AbstractCustomerInfo, created: Bool) {
        throw NoopManagerError.unavailableOnWatchOS
    }

    func setEmail(email _: String) {}

    func logout() async throws -> any AbstractCustomerInfo {
        throw NoopManagerError.unavailableOnWatchOS
    }

    func setAttribution(adid _: String) {}

    func setAmplitudeUserId(userId _: String) {}

    func syncPurchase() async throws -> any AbstractCustomerInfo {
        throw NoopManagerError.unavailableOnWatchOS
    }

    func customerInfo() async throws -> any AbstractCustomerInfo {
        throw NoopManagerError.unavailableOnWatchOS
    }

    func fetchOfferings() async throws -> (any AbstractOfferings)? { nil }

    func fetchCurrentOffering() async throws -> (any AbstractOffering)? { nil }

    func restorePurchases() async throws -> any AbstractCustomerInfo {
        throw NoopManagerError.unavailableOnWatchOS
    }

    func purchase(package _: any AbstractPackage) async throws -> any AbstractPurchaseResultData {
        throw NoopManagerError.unavailableOnWatchOS
    }

    func purchaseProduct(withId _: String) async throws -> any AbstractPurchaseResultData {
        throw NoopManagerError.unavailableOnWatchOS
    }

    func checkTrialOrIntroDiscountEligibility(productIdentifiers _: [String]) async -> [String: Int] { [:] }

    func setPurchaseDelegate(_: any KovaleePurchasesDelegate) {}

    func cancellableStripeSubscriptionId() async throws -> String? { nil }

    func handleWebRedemptionURL(_: URL) async throws -> Bool { false }

    func handleWebUser(withId _: String) async throws -> Bool { false }

    func isRCWebPurchaseRedemptionURL(_: URL) -> Bool { false }
}
#endif
