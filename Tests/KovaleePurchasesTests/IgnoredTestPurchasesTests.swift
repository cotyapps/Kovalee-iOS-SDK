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
        let storage = IgnoredProductIDStorage(service: "kovalee.tests.\(UUID().uuidString)")
        defer { storage.update { $0.removeAll() } }
        #expect(storage.productIDs.isEmpty)

        #expect(storage.update { _ = $0.insert(weekly) })
        #expect(storage.productIDs == [weekly])
        #expect(!storage.update { _ = $0.insert(weekly) })

        #expect(storage.update { _ = $0.remove(weekly) })
        #expect(storage.productIDs.isEmpty)
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
