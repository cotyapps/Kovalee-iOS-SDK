import Foundation
import RevenueCat
import Testing
@testable import KovaleePurchases

/// The promise that matters: ignoring test purchases can make a tester free, and can
/// never make a paying customer free.
@Suite("Ignored test purchases")
struct IgnoredTestPurchasesTests {
    private let weekly = "subs.weekly"
    private let yearly = "subs.yearly"
    private let lifetime = "lifetime"

    // MARK: - The rule

    @Test func ignoresAListedAppStoreSandboxPurchase() {
        #expect(IgnoredTestPurchases.ignores(
            productID: weekly, isSandbox: true, isAppStore: true, ignoredProductIDs: [weekly]
        ))
    }

    @Test func neverIgnoresAProductionPurchase() {
        #expect(!IgnoredTestPurchases.ignores(
            productID: weekly, isSandbox: false, isAppStore: true, ignoredProductIDs: [weekly]
        ))
    }

    @Test func neverIgnoresAnotherStoresPurchase() {
        #expect(!IgnoredTestPurchases.ignores(
            productID: weekly, isSandbox: true, isAppStore: false, ignoredProductIDs: [weekly]
        ))
    }

    @Test func onlyIgnoresListedProducts() {
        #expect(!IgnoredTestPurchases.ignores(
            productID: yearly, isSandbox: true, isAppStore: true, ignoredProductIDs: [weekly]
        ))
    }

    // MARK: - On RevenueCat's customer info

    @Test func ignoringTheTestSubscriptionMakesTheTesterFree() throws {
        let info = try customerInfo(subscriptions: [weekly: .sandbox], entitlementProduct: weekly)
        #expect(IgnoredTestPurchases.isPremium(info, ignoring: []))

        #expect(!IgnoredTestPurchases.isPremium(info, ignoring: [weekly]))
        let wrapped = KCustomerInfo(info: info, ignoring: [weekly])
        #expect(wrapped.activeSubscriptions.isEmpty)
        #expect(!wrapped.activeEntitlements)
        #expect(wrapped.entitlements.all["premium"]?.isActive == false)
    }

    @Test func ignoringATestLifetimePurchaseMakesTheTesterFree() throws {
        let info = try customerInfo(lifetimes: [lifetime: .sandbox], entitlementProduct: lifetime)
        #expect(IgnoredTestPurchases.isPremium(info, ignoring: []))

        #expect(!IgnoredTestPurchases.isPremium(info, ignoring: [lifetime]))
        #expect(!KCustomerInfo(info: info, ignoring: [lifetime]).activeEntitlements)
    }

    @Test func aPayingCustomerStaysPremiumEvenWithTheirProductListed() throws {
        let info = try customerInfo(subscriptions: [weekly: .production], entitlementProduct: weekly)

        #expect(IgnoredTestPurchases.isPremium(info, ignoring: [weekly]))
        let wrapped = KCustomerInfo(info: info, ignoring: [weekly])
        #expect(wrapped.activeSubscriptions == [weekly])
        #expect(wrapped.activeEntitlements)
    }

    @Test func aPayingLifetimeCustomerStaysPremiumEvenWithTheirProductListed() throws {
        let info = try customerInfo(lifetimes: [lifetime: .production], entitlementProduct: lifetime)

        #expect(IgnoredTestPurchases.isPremium(info, ignoring: [lifetime]))
        #expect(KCustomerInfo(info: info, ignoring: [lifetime]).activeEntitlements)
    }

    @Test func aWebPurchaseIsNeverIgnored() throws {
        let info = try customerInfo(subscriptions: [weekly: .stripeSandbox], entitlementProduct: weekly)

        #expect(IgnoredTestPurchases.isPremium(info, ignoring: [weekly]))
    }

    @Test func anotherTestPurchaseKeepsTheTesterPremium() throws {
        let info = try customerInfo(
            subscriptions: [weekly: .sandbox, yearly: .sandbox],
            entitlementProduct: yearly
        )

        #expect(IgnoredTestPurchases.isPremium(info, ignoring: [weekly]))
        #expect(KCustomerInfo(info: info, ignoring: [weekly]).activeSubscriptions == [yearly])
    }

    @Test func ignoringOneOfTwoProductsKeepsTheEntitlement() throws {
        // RevenueCat names the lifetime as the entitlement's product, but the weekly,
        // which isn't ignored, still grants it.
        let info = try customerInfo(
            subscriptions: [weekly: .sandbox],
            lifetimes: [lifetime: .sandbox],
            entitlementProduct: lifetime
        )
        let wrapped = KCustomerInfo(info: info, ignoring: [lifetime])

        #expect(IgnoredTestPurchases.isPremium(info, ignoring: [lifetime]))
        #expect(wrapped.entitlements.all["premium"]?.isActive == true)
        #expect(wrapped.nonSubscriptionProductIds.isEmpty)
    }

    @Test func ignoringEveryProductSwitchesTheEntitlementOff() throws {
        let info = try customerInfo(
            subscriptions: [weekly: .sandbox],
            lifetimes: [lifetime: .sandbox],
            entitlementProduct: lifetime
        )

        #expect(!IgnoredTestPurchases.isPremium(info, ignoring: [lifetime, weekly]))
        #expect(!KCustomerInfo(info: info, ignoring: [lifetime, weekly]).activeEntitlements)
    }

    @Test func ignoredPurchasesLeaveEveryFieldOfTheCustomerInfo() throws {
        let info = try customerInfo(
            subscriptions: [weekly: .sandbox],
            lifetimes: [lifetime: .sandbox],
            entitlementProduct: lifetime
        )
        let wrapped = KCustomerInfo(info: info, ignoring: [lifetime, weekly])

        #expect(wrapped.nonSubscriptions.isEmpty)
        #expect(wrapped.allPurchasedProductIdentifiers.isEmpty)
        #expect(wrapped.latestExpirationDate == nil)
        #expect(wrapped.activeSubscriptions.isEmpty)
    }

    @Test func aPayingCustomersHistoryIsKept() throws {
        let info = try customerInfo(
            subscriptions: [weekly: .production],
            lifetimes: [lifetime: .production],
            entitlementProduct: lifetime
        )
        let wrapped = KCustomerInfo(info: info, ignoring: [lifetime, weekly])

        #expect(wrapped.nonSubscriptionProductIds == [lifetime])
        #expect(wrapped.allPurchasedProductIdentifiers == [lifetime, weekly])
        #expect(wrapped.latestExpirationDate == info.latestExpirationDate)
        #expect(wrapped.activeEntitlements)
    }

    @Test func nothingIgnoredLeavesRevenueCatsAnswer() throws {
        let info = try customerInfo(subscriptions: [weekly: .sandbox], entitlementProduct: weekly)
        let wrapped = KCustomerInfo(info: info, ignoring: [])

        #expect(wrapped.activeSubscriptions == info.activeSubscriptions)
        #expect(wrapped.activeEntitlements)
    }

    @Test func aFreeUserStaysFree() throws {
        let info = try customerInfo(entitlementProduct: nil)

        #expect(!IgnoredTestPurchases.isPremium(info, ignoring: []))
        #expect(!KCustomerInfo(info: info, ignoring: []).activeEntitlements)
    }

    // MARK: - Storage

    @Test func storageAddsAndRemovesProducts() {
        let store = MemoryStore()
        let storage = IgnoredProductIDStorage(store: store)
        #expect(storage.productIDs.isEmpty)

        #expect(storage.update { _ = $0.insert(weekly) })
        #expect(store.saved == [weekly])
        #expect(!storage.update { _ = $0.insert(weekly) })

        #expect(storage.update { _ = $0.remove(weekly) })
        #expect(store.saved == [])
        #expect(storage.productIDs.isEmpty)
    }

    @Test func anUnreadableStoreIsNotTakenForAnEmptyList() {
        // Before the first unlock after a reboot, the Keychain can't be read.
        let store = MemoryStore(saved: [lifetime], isReadable: false)
        let storage = IgnoredProductIDStorage(store: store)

        #expect(storage.productIDs.isEmpty)
        #expect(!storage.update { _ = $0.insert(weekly) })
        #expect(store.saved == [lifetime])

        store.isReadable = true
        #expect(storage.productIDs == [lifetime])
        #expect(storage.update { _ = $0.insert(weekly) })
        #expect(store.saved == [lifetime, weekly])
    }

    @Test func aFailedSaveChangesNothing() {
        let store = MemoryStore(isWritable: false)
        let storage = IgnoredProductIDStorage(store: store)

        #expect(!storage.update { _ = $0.insert(weekly) })
        #expect(storage.productIDs.isEmpty)
    }

    /// Needs a Keychain: an app-hosted test bundle. A hostless iOS simulator bundle
    /// has none (errSecMissingEntitlement), so the test is skipped there.
    @Test(.enabled(if: KeychainProbe.isAvailable, "needs a Keychain (an app-hosted test bundle)"))
    func theKeychainKeepsTheList() {
        let store = KeychainIgnoredProductIDStore(service: "kovalee.tests.\(UUID().uuidString)")
        defer { _ = store.save([]) }

        #expect(store.load() == [])
        #expect(store.save([weekly, lifetime]))
        #expect(store.load() == [weekly, lifetime])
        #expect(store.save([weekly]))
        #expect(store.load() == [weekly])
        #expect(store.save([]))
        #expect(store.load() == [])
    }

    // MARK: - Helpers

    private enum Origin {
        case sandbox
        case production
        case stripeSandbox

        var store: String { self == .stripeSandbox ? "stripe" : "app_store" }
        var isSandbox: Bool { self != .production }
    }

    /// A customer info in RevenueCat's backend format, active until 2099, with one
    /// `premium` entitlement granted by `entitlementProduct`.
    private func customerInfo(
        subscriptions: [String: Origin] = [:],
        lifetimes: [String: Origin] = [:],
        entitlementProduct: String?
    ) throws -> CustomerInfo {
        let bought = "2026-11-25T12:00:00Z"
        var subscriber: [String: Any] = [
            "original_app_user_id": "$RCAnonymousID:0123456789abcdef0123456789abcdef",
            "first_seen": bought,
            "original_application_version": NSNull(),
            "original_purchase_date": NSNull(),
            "management_url": NSNull(),
            "other_purchases": [String: Any](),
        ]
        subscriber["subscriptions"] = subscriptions.mapValues { origin -> [String: Any] in
            [
                "purchase_date": bought,
                "original_purchase_date": bought,
                "expires_date": "2099-01-01T00:00:00Z",
                "period_type": "normal",
                "store": origin.store,
                "is_sandbox": origin.isSandbox,
                "ownership_type": "PURCHASED",
                "unsubscribe_detected_at": NSNull(),
                "billing_issues_detected_at": NSNull(),
            ]
        }
        subscriber["non_subscriptions"] = lifetimes.mapValues { origin -> [[String: Any]] in
            [[
                "id": UUID().uuidString,
                "store_transaction_id": "1000000000000001",
                "purchase_date": bought,
                "original_purchase_date": bought,
                "store": origin.store,
                "is_sandbox": origin.isSandbox,
            ]]
        }
        if let entitlementProduct {
            subscriber["entitlements"] = [
                "premium": [
                    "product_identifier": entitlementProduct,
                    "purchase_date": bought,
                    "expires_date": lifetimes[entitlementProduct] == nil ? "2099-01-01T00:00:00Z" as Any : NSNull(),
                ] as [String: Any],
            ]
        } else {
            subscriber["entitlements"] = [String: Any]()
        }

        let json: [String: Any] = [
            "request_date": "2026-11-26T12:00:00Z",
            "subscriber": subscriber,
        ]
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(CustomerInfo.self, from: JSONSerialization.data(withJSONObject: json))
    }
}

/// An in-memory store that can fail like the Keychain does.
private final class MemoryStore: IgnoredProductIDStore, @unchecked Sendable {
    var saved: Set<String>
    var isReadable: Bool
    var isWritable: Bool

    init(saved: Set<String> = [], isReadable: Bool = true, isWritable: Bool = true) {
        self.saved = saved
        self.isReadable = isReadable
        self.isWritable = isWritable
    }

    func load() -> Set<String>? {
        isReadable ? saved : nil
    }

    func save(_ ids: Set<String>) -> Bool {
        guard isWritable else { return false }
        saved = ids
        return true
    }
}

private enum KeychainProbe {
    static let isAvailable: Bool = {
        let store = KeychainIgnoredProductIDStore(service: "kovalee.tests.probe.\(UUID().uuidString)")
        defer { _ = store.save([]) }
        return store.save(["probe"])
    }()
}
