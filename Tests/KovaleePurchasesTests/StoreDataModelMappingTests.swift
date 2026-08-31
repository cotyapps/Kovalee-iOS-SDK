import Foundation
import RevenueCat
import XCTest

@testable import KovaleePurchases

/// Covers the RevenueCat -> Kovalee mapping in `StoreDataModel.swift`.
///
/// These are the guarantees the overlapping-subscription banner depends on: that two subscriptions
/// granting the same entitlement both survive the mapping, and that no field is silently coerced.
final class StoreDataModelMappingTests: XCTestCase {

    // MARK: - Per-product subscription info

    /// The headline case. RevenueCat resolves each entitlement to a single winning product, so two
    /// products granting `premium` collapse to one `KEntitlementInfo`. `subscriptionsByProductIdentifier`
    /// must keep both — this is precisely what makes double billing detectable.
    func testOverlappingSubscriptionsSurviveEntitlementCollapse() throws {
        let json = CustomerInfoFixture.response(
            subscriptions: [
                "monthly.sub": CustomerInfoFixture.subscription(),
                "annual.sub": CustomerInfoFixture.subscription(),
            ],
            entitlements: [
                "premium": CustomerInfoFixture.entitlement(productIdentifier: "monthly.sub"),
            ]
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))

        // Entitlements collapse to the single winning product...
        XCTAssertEqual(info.entitlements.all.count, 1)
        XCTAssertEqual(info.entitlements.all["premium"]?.productIdentifier, "monthly.sub")

        // ...but both subscription records are preserved, under their exact product identifiers.
        XCTAssertEqual(Set(info.subscriptionsByProductIdentifier.keys), ["monthly.sub", "annual.sub"])
        XCTAssertEqual(info.subscriptionsByProductIdentifier["monthly.sub"]?.isActive, true)
        XCTAssertEqual(info.subscriptionsByProductIdentifier["annual.sub"]?.isActive, true)
    }

    func testSubscriptionInfoMapsEveryField() throws {
        let json = CustomerInfoFixture.response(
            subscriptions: [
                "monthly.sub": CustomerInfoFixture.subscription(
                    expiresDate: "2100-03-14T09:00:00Z",
                    purchaseDate: "2026-02-14T09:00:00Z",
                    store: "stripe",
                    isSandbox: true,
                    ownershipType: "FAMILY_SHARED",
                    periodType: "trial",
                    refundedAt: "2026-05-01T00:00:00Z"
                ),
            ]
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))
        let subscription = try XCTUnwrap(info.subscriptionsByProductIdentifier["monthly.sub"])

        XCTAssertEqual(subscription.store, .stripe)
        XCTAssertTrue(subscription.isSandbox)
        XCTAssertEqual(subscription.ownershipType, .familyShared)
        XCTAssertEqual(subscription.periodType, .trial)
        XCTAssertEqual(subscription.refundedAt, ISO8601DateFormatter().date(from: "2026-05-01T00:00:00Z"))
        XCTAssertEqual(subscription.expiresDate, ISO8601DateFormatter().date(from: "2100-03-14T09:00:00Z"))
        XCTAssertEqual(subscription.purchaseDate, ISO8601DateFormatter().date(from: "2026-02-14T09:00:00Z"))
    }

    /// A second subscription that is already cancelled is not double billing — it is simply running
    /// out its term. `willRenew` is the field that separates the two, and it is unavailable per
    /// product anywhere else.
    func testCancelledSubscriptionReportsWillRenewFalse() throws {
        let json = CustomerInfoFixture.response(
            subscriptions: [
                "renewing.sub": CustomerInfoFixture.subscription(),
                "cancelled.sub": CustomerInfoFixture.subscription(
                    unsubscribeDetectedAt: "2026-05-01T00:00:00Z"
                ),
            ]
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))

        XCTAssertEqual(info.subscriptionsByProductIdentifier["renewing.sub"]?.willRenew, true)
        XCTAssertEqual(info.subscriptionsByProductIdentifier["cancelled.sub"]?.willRenew, false)
        // Both are still active — an unsubscribed user keeps access until expiry.
        XCTAssertEqual(info.subscriptionsByProductIdentifier["cancelled.sub"]?.isActive, true)
    }

    func testExpiredSubscriptionIsReportedInactiveButRetained() throws {
        let json = CustomerInfoFixture.response(
            subscriptions: [
                "expired.sub": CustomerInfoFixture.subscription(expiresDate: "2020-01-01T00:00:00Z"),
            ]
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))

        XCTAssertEqual(info.subscriptionsByProductIdentifier["expired.sub"]?.isActive, false)
        XCTAssertTrue(info.activeSubscriptions.isEmpty)
    }

    func testNoSubscriptionsYieldsEmptyDictionaryRatherThanFailing() throws {
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: CustomerInfoFixture.response()))

        XCTAssertTrue(info.subscriptionsByProductIdentifier.isEmpty)
        XCTAssertTrue(info.nonSubscriptions.isEmpty)
        XCTAssertTrue(info.entitlements.all.isEmpty)
    }

    // MARK: - Non-subscription transactions

    func testNonSubscriptionStoreAndSandboxAreMapped() throws {
        let json = CustomerInfoFixture.response(
            nonSubscriptions: [
                "lifetime": [CustomerInfoFixture.transaction(id: "t1", store: "stripe", isSandbox: true)],
            ]
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))
        let transaction = try XCTUnwrap(info.nonSubscriptions.first)

        XCTAssertEqual(transaction.productIdentifier, "lifetime")
        XCTAssertEqual(transaction.store, .stripe)
        XCTAssertTrue(transaction.isSandbox)
    }

    /// A consumable bought repeatedly produces several records under one product identifier. None
    /// may be deduplicated away.
    func testDuplicateNonSubscriptionProductIdentifiersArePreserved() throws {
        let json = CustomerInfoFixture.response(
            nonSubscriptions: [
                "coins": [
                    CustomerInfoFixture.transaction(id: "t1"),
                    CustomerInfoFixture.transaction(id: "t2"),
                    CustomerInfoFixture.transaction(id: "t3"),
                ],
            ]
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))

        XCTAssertEqual(info.nonSubscriptions.count, 3)
        XCTAssertEqual(Set(info.nonSubscriptions.map(\.transactionIdentifier)), ["t1", "t2", "t3"])
        XCTAssertEqual(info.nonSubscriptions.map(\.productIdentifier), ["coins", "coins", "coins"])
    }

    // MARK: - Store mapping

    /// Guards against `KStore` drifting behind RevenueCat again — `paddle`, `testStore` and `galaxy`
    /// were all silently degrading to `.unknownStore` before this change.
    func testKStoreCoversEveryRevenueCatStore() {
        for rawValue in 0..<64 {
            guard let rcStore = RevenueCat.Store(rawValue: rawValue) else { continue }
            XCTAssertNotNil(
                KStore(rawValue: rawValue),
                "KStore is missing a case for RevenueCat.Store.\(rcStore) (rawValue \(rawValue))"
            )
        }
    }

    /// Same drift guard as `testKStoreCoversEveryRevenueCatStore`, for period types — `prepaid`
    /// was already missing here and mapped to `nil`.
    func testKPeriodTypeCoversEveryRevenueCatPeriodType() {
        for rawValue in 0..<64 {
            guard let rcPeriodType = RevenueCat.PeriodType(rawValue: rawValue) else { continue }
            XCTAssertNotNil(
                KPeriodType(rawValue: rawValue),
                "KPeriodType is missing a case for RevenueCat.PeriodType.\(rcPeriodType) (rawValue \(rawValue))"
            )
        }
    }

    /// A store string RevenueCat does not recognise degrades that single record to `.unknownStore`
    /// and leaves its neighbours intact — one unknown store must not take the whole dictionary with it.
    func testUnknownStoreStringDegradesOnlyTheAffectedSubscription() throws {
        let json = CustomerInfoFixture.response(
            subscriptions: [
                "mystery.sub": CustomerInfoFixture.subscription(store: "not_a_real_store"),
                "normal.sub": CustomerInfoFixture.subscription(store: "app_store"),
            ]
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))

        XCTAssertEqual(Set(info.subscriptionsByProductIdentifier.keys), ["mystery.sub", "normal.sub"])
        XCTAssertEqual(info.subscriptionsByProductIdentifier["mystery.sub"]?.store, .unknownStore)
        XCTAssertEqual(info.subscriptionsByProductIdentifier["normal.sub"]?.store, .appStore)
    }

    /// Non-subscription transactions tolerate an unknown store per record, unlike subscriptions.
    func testUnrecognisedStoreOnNonSubscriptionDegradesPerRecord() throws {
        let json = CustomerInfoFixture.response(
            nonSubscriptions: [
                "lifetime": [CustomerInfoFixture.transaction(id: "t1", store: "not_a_real_store")],
            ]
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))

        XCTAssertEqual(info.nonSubscriptions.first?.store, .unknownStore)
    }

    /// Only wire values that exist at the package's declared RevenueCat floor (5.25.3) are asserted
    /// here — `paddle`, `test_store` and `galaxy` were added in 5.26.0/5.34.0/5.56.0 and would
    /// decode to `.unknownStore` on the minimum supported version. `testKStoreCoversEveryRevenueCatStore`
    /// covers those against whatever version is actually linked.
    func testKnownStoresMapExactly() throws {
        let expected: [(wire: String, store: KStore)] = [
            ("app_store", .appStore),
            ("mac_app_store", .macAppStore),
            ("play_store", .playStore),
            ("stripe", .stripe),
            ("promotional", .promotional),
            ("amazon", .amazon),
            ("rc_billing", .rcBilling),
            ("external", .external),
        ]

        for (wire, store) in expected {
            let json = CustomerInfoFixture.response(
                subscriptions: ["sub": CustomerInfoFixture.subscription(store: wire)]
            )
            let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))
            XCTAssertEqual(info.subscriptionsByProductIdentifier["sub"]?.store, store, "wire value \(wire)")
        }
    }

    // MARK: - Raw-value identity with RevenueCat

    /// Pins case-for-case identity, not just existence — if RevenueCat ever renumbered `Store`,
    /// the existence-based drift guards above would still pass while every higher case mapped to
    /// the wrong store.
    func testKStoreRawValuesMatchRevenueCat() {
        XCTAssertEqual(KStore.appStore.rawValue, RevenueCat.Store.appStore.rawValue)
        XCTAssertEqual(KStore.macAppStore.rawValue, RevenueCat.Store.macAppStore.rawValue)
        XCTAssertEqual(KStore.playStore.rawValue, RevenueCat.Store.playStore.rawValue)
        XCTAssertEqual(KStore.stripe.rawValue, RevenueCat.Store.stripe.rawValue)
        XCTAssertEqual(KStore.promotional.rawValue, RevenueCat.Store.promotional.rawValue)
        XCTAssertEqual(KStore.unknownStore.rawValue, RevenueCat.Store.unknownStore.rawValue)
        XCTAssertEqual(KStore.amazon.rawValue, RevenueCat.Store.amazon.rawValue)
        XCTAssertEqual(KStore.rcBilling.rawValue, RevenueCat.Store.rcBilling.rawValue)
        XCTAssertEqual(KStore.external.rawValue, RevenueCat.Store.external.rawValue)
        XCTAssertEqual(KStore.paddle.rawValue, RevenueCat.Store.paddle.rawValue)
        XCTAssertEqual(KStore.testStore.rawValue, RevenueCat.Store.testStore.rawValue)
        XCTAssertEqual(KStore.galaxy.rawValue, RevenueCat.Store.galaxy.rawValue)
    }

    func testKPeriodTypeRawValuesMatchRevenueCat() {
        XCTAssertEqual(KPeriodType.normal.rawValue, RevenueCat.PeriodType.normal.rawValue)
        XCTAssertEqual(KPeriodType.intro.rawValue, RevenueCat.PeriodType.intro.rawValue)
        XCTAssertEqual(KPeriodType.trial.rawValue, RevenueCat.PeriodType.trial.rawValue)
        XCTAssertEqual(KPeriodType.prepaid.rawValue, RevenueCat.PeriodType.prepaid.rawValue)
    }

    // MARK: - Verification

    /// `KVerificationResult` mirrors RevenueCat's raw values, which are *not* sequential —
    /// `failed` is 2 and `verifiedOnDevice` is 3. Renumbering would report a tampered payload as
    /// verified, so pin the pairing.
    func testVerificationRawValuesMatchRevenueCat() {
        XCTAssertEqual(KVerificationResult.notRequested.rawValue, RevenueCat.VerificationResult.notRequested.rawValue)
        XCTAssertEqual(KVerificationResult.verified.rawValue, RevenueCat.VerificationResult.verified.rawValue)
        XCTAssertEqual(KVerificationResult.failed.rawValue, RevenueCat.VerificationResult.failed.rawValue)
        XCTAssertEqual(
            KVerificationResult.verifiedOnDevice.rawValue,
            RevenueCat.VerificationResult.verifiedOnDevice.rawValue
        )
    }

    func testEveryVerificationStateIsPreserved() throws {
        let expected: [(raw: Int, result: KVerificationResult)] = [
            (0, .notRequested),
            (1, .verified),
            (2, .failed),
            (3, .verifiedOnDevice),
        ]

        for (raw, result) in expected {
            let json = CustomerInfoFixture.response(entitlementVerification: raw)
            let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))
            XCTAssertEqual(info.entitlements.verification, result, "raw value \(raw)")
        }
    }

    /// An absent verification field must stay `.notRequested` rather than being read as success.
    func testAbsentVerificationIsNeverUpgraded() throws {
        let json = CustomerInfoFixture.response(entitlementVerification: nil)
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))

        XCTAssertEqual(info.entitlements.verification, .notRequested)
    }

    // MARK: - Ownership

    func testPeriodTypeMapping() throws {
        let expected: [(wire: String, type: KPeriodType?)] = [
            ("normal", .normal),
            ("intro", .intro),
            ("trial", .trial),
            ("prepaid", .prepaid),
        ]

        for (wire, type) in expected {
            let json = CustomerInfoFixture.response(
                subscriptions: ["sub": CustomerInfoFixture.subscription(periodType: wire)]
            )
            let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))
            XCTAssertEqual(info.subscriptionsByProductIdentifier["sub"]?.periodType, type, "wire value \(wire)")
        }
    }

    func testOwnershipTypeMapping() throws {
        let expected: [(wire: String, type: KPurchaseOwnershipType)] = [
            ("PURCHASED", .purchased),
            ("FAMILY_SHARED", .familyShared),
            ("NOT_A_REAL_TYPE", .unknown),
        ]

        for (wire, type) in expected {
            let json = CustomerInfoFixture.response(
                subscriptions: ["sub": CustomerInfoFixture.subscription(ownershipType: wire)]
            )
            let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))
            XCTAssertEqual(info.subscriptionsByProductIdentifier["sub"]?.ownershipType, type, "wire value \(wire)")
        }
    }

    // MARK: - Subscription period

    /// Exercises the real `KSubscriptionPeriod(_:)` mapping rather than the raw-value initializer,
    /// so a changed fallback would actually fail this.
    func testSubscriptionPeriodUnitsMapThroughProductionInitializer() {
        let expected: [(RevenueCat.SubscriptionPeriod.Unit, KSubscriptionPeriod.Unit)] = [
            (.day, .day),
            (.week, .week),
            (.month, .month),
            (.year, .year),
        ]

        for (rcUnit, expectedUnit) in expected {
            let period = KSubscriptionPeriod(RevenueCat.SubscriptionPeriod(value: 3, unit: rcUnit))
            XCTAssertEqual(period.unit, expectedUnit)
            XCTAssertEqual(period.value, 3)
        }
    }

    /// Drift guard: a unit added by a future RevenueCat would hit the `.day` fallback in
    /// `KSubscriptionPeriod(_:)`, quietly skewing every price-per-month figure derived from it.
    func testKSubscriptionPeriodUnitCoversEveryRevenueCatUnit() {
        for rawValue in 0..<64 {
            guard let rcUnit = RevenueCat.SubscriptionPeriod.Unit(rawValue: rawValue) else { continue }
            XCTAssertNotNil(
                KSubscriptionPeriod.Unit(rawValue: rawValue),
                "KSubscriptionPeriod.Unit is missing a case for \(rcUnit) (rawValue \(rawValue))"
            )
        }
    }

    // MARK: - Legacy API compatibility

    /// Everything the SDK exposed before this change must behave identically.
    func testExistingCustomerInfoApisAreUnchanged() throws {
        let json = CustomerInfoFixture.response(
            subscriptions: [
                "monthly.sub": CustomerInfoFixture.subscription(),
                "expired.sub": CustomerInfoFixture.subscription(expiresDate: "2020-01-01T00:00:00Z"),
            ],
            nonSubscriptions: ["lifetime": [CustomerInfoFixture.transaction(id: "t1")]],
            entitlements: ["premium": CustomerInfoFixture.entitlement(productIdentifier: "monthly.sub")]
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))

        XCTAssertEqual(info.activeSubscriptions, ["monthly.sub"])
        XCTAssertEqual(info.allPurchasedProductIdentifiers, ["monthly.sub", "expired.sub", "lifetime"])
        XCTAssertEqual(info.nonSubscriptionProductIds, ["lifetime"])
        XCTAssertTrue(info.activeEntitlements)
        XCTAssertFalse(info.isInTrialPeriod)
        XCTAssertEqual(info.originalAppUserId, "test-user")
        XCTAssertEqual(info.entitlements["premium"]?.identifier, "premium")
        XCTAssertNotNil(info.managementURL)
    }

    /// `KCustomerInfo` is `Encodable` with synthesized conformance, so a new stored property that
    /// was not itself `Encodable` would break encoding at runtime rather than at compile time.
    func testCustomerInfoStillEncodes() throws {
        let json = CustomerInfoFixture.response(
            subscriptions: ["monthly.sub": CustomerInfoFixture.subscription()],
            nonSubscriptions: ["lifetime": [CustomerInfoFixture.transaction(id: "t1")]],
            entitlementVerification: 1
        )
        let info = KCustomerInfo(info: try CustomerInfoFixture.customerInfo(json: json))

        let encoded = try JSONEncoder().encode(info)
        let object = try XCTUnwrap(
            JSONSerialization.jsonObject(with: encoded) as? [String: Any]
        )
        XCTAssertNotNil(object["subscriptionsByProductIdentifier"])
    }
}
