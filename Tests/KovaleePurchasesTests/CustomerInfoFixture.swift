import Foundation
import RevenueCat

/// Builds `RevenueCat.CustomerInfo` values from JSON, which is the only public construction path
/// (`CustomerInfo` exposes `init(from:)` but no memberwise initializer).
///
/// The decoder mirrors RevenueCat's own internal `JSONDecoder.default` — `.convertFromSnakeCase`
/// keys and `.iso8601` dates — so fixtures here are written in the same shape as a real
/// `/subscribers` API response.
///
/// - Warning: `.convertFromSnakeCase` rewrites *dictionary keys* too, not just property names —
///   a product identifier like `"rc_499_1m"` decodes under the key `"rc4991M"` and lookups
///   silently return `nil`. Use dot-separated identifiers (`"monthly.sub"`) in fixtures.
enum CustomerInfoFixture {

    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    static func customerInfo(json: String) throws -> CustomerInfo {
        try decoder().decode(CustomerInfo.self, from: Data(json.utf8))
    }

    // MARK: - Response building blocks

    /// One entry of `subscriber.subscriptions`.
    ///
    /// - Parameter store: written as the raw wire string (e.g. `"app_store"`, `"paddle"`), so tests
    ///   can feed values this SDK's `KStore` does not know about.
    static func subscription(
        expiresDate: String? = "2100-01-01T00:00:00Z",
        purchaseDate: String = "2026-01-01T00:00:00Z",
        store: String = "app_store",
        isSandbox: Bool = false,
        ownershipType: String = "PURCHASED",
        periodType: String = "normal",
        unsubscribeDetectedAt: String? = nil,
        billingIssuesDetectedAt: String? = nil,
        refundedAt: String? = nil,
        price: (currency: String, amount: Double)? = nil
    ) -> String {
        var fields: [String] = [
            "\"purchase_date\": \"\(purchaseDate)\"",
            "\"original_purchase_date\": \"\(purchaseDate)\"",
            "\"store\": \"\(store)\"",
            "\"is_sandbox\": \(isSandbox)",
            "\"ownership_type\": \"\(ownershipType)\"",
            "\"period_type\": \"\(periodType)\"",
        ]
        fields.append("\"expires_date\": \(expiresDate.map { "\"\($0)\"" } ?? "null")")
        fields.append("\"unsubscribe_detected_at\": \(unsubscribeDetectedAt.map { "\"\($0)\"" } ?? "null")")
        fields.append("\"billing_issues_detected_at\": \(billingIssuesDetectedAt.map { "\"\($0)\"" } ?? "null")")
        fields.append("\"refunded_at\": \(refundedAt.map { "\"\($0)\"" } ?? "null")")
        if let price {
            fields.append("\"price\": {\"currency\": \"\(price.currency)\", \"amount\": \(price.amount)}")
        }
        return "{\(fields.joined(separator: ", "))}"
    }

    /// One entry of a `subscriber.non_subscriptions` array.
    static func transaction(
        id: String,
        purchaseDate: String = "2026-01-01T00:00:00Z",
        store: String = "app_store",
        isSandbox: Bool = false
    ) -> String {
        """
        {
            "id": "\(id)",
            "purchase_date": "\(purchaseDate)",
            "original_purchase_date": "\(purchaseDate)",
            "store_transaction_id": "\(id)",
            "store": "\(store)",
            "is_sandbox": \(isSandbox)
        }
        """
    }

    /// One entry of `subscriber.entitlements`.
    static func entitlement(
        productIdentifier: String,
        expiresDate: String? = "2100-01-01T00:00:00Z",
        purchaseDate: String = "2026-01-01T00:00:00Z"
    ) -> String {
        """
        {
            "product_identifier": "\(productIdentifier)",
            "purchase_date": "\(purchaseDate)",
            "expires_date": \(expiresDate.map { "\"\($0)\"" } ?? "null")
        }
        """
    }

    /// Assembles a full `/subscribers` response body.
    ///
    /// - Parameter entitlementVerification: raw `VerificationResult` value — 0 notRequested,
    ///   1 verified, 2 failed, 3 verifiedOnDevice. Omitted entirely when `nil`.
    static func response(
        subscriptions: [String: String] = [:],
        nonSubscriptions: [String: [String]] = [:],
        entitlements: [String: String] = [:],
        entitlementVerification: Int? = nil,
        requestDate: String = "2026-06-01T00:00:00Z",
        firstSeen: String = "2025-01-01T00:00:00Z"
    ) -> String {
        func dictionary(_ entries: [String: String]) -> String {
            entries.map { "\"\($0.key)\": \($0.value)" }.joined(separator: ", ")
        }
        let nonSubs = nonSubscriptions
            .map { "\"\($0.key)\": [\($0.value.joined(separator: ", "))]" }
            .joined(separator: ", ")

        var top: [String] = [
            "\"request_date\": \"\(requestDate)\"",
            """
            "subscriber": {
                "original_app_user_id": "test-user",
                "first_seen": "\(firstSeen)",
                "original_purchase_date": "\(firstSeen)",
                "management_url": "https://apps.apple.com/account/subscriptions",
                "subscriptions": {\(dictionary(subscriptions))},
                "non_subscriptions": {\(nonSubs)},
                "entitlements": {\(dictionary(entitlements))}
            }
            """,
        ]
        if let entitlementVerification {
            top.append("\"entitlement_verification\": \(entitlementVerification)")
        }
        return "{\(top.joined(separator: ", "))}"
    }
}
