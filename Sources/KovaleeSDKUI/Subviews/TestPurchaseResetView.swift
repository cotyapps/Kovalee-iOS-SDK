#if os(iOS) || os(visionOS)
    @_spi(KovaleeDebug) import KovaleePurchases
    import KovaleeSDK
    import RevenueCat
    import StoreKit
    import SwiftUI

    /// Debug and TestFlight builds only: lets a tester get back to a free user although
    /// a TestFlight purchase can't be wiped, a lifetime one included.
    ///
    /// - **Ignore** a purchase, one product at a time (see ``IgnoredTestPurchases``):
    ///   the app treats it as not bought until the tester stops ignoring it, buys it
    ///   again or restores. Only App Store sandbox purchases are ever ignored.
    /// - **Refund** removes a purchase for good: in test environments Apple approves
    ///   every refund request at once, whatever reason the tester picks, and revokes
    ///   the purchase, so it can be bought again.
    /// - **New RevenueCat user** starts a customer with no history.
    ///
    /// Changes reach the app when the console closes (``DebugConsoleChanges``), since
    /// the app can't present its paywall over the console.
    @available(iOS 16.0, *)
    struct TestPurchaseResetView: View {
        /// Called after a change, so the console's Purchases section reloads.
        var onChange: () -> Void = {}

        @State private var rows: [TestPurchaseRow]?
        @State private var ignoredProductIDs = IgnoredTestPurchases.productIDs
        @State private var refundTarget: TestPurchaseRow?
        @State private var isRefundSheetPresented = false
        @State private var isManagingSubscriptions = false
        @State private var isConfirmingNewUser = false
        @State private var isWorking = false
        @State private var outcome: Outcome?
        @State private var revenueCatUserId = ""

        var body: some View {
            Group {
                purchaseRows
                revenueCatRow
                if let outcome {
                    outcomeRow(outcome)
                }
            }
            .refundRequestSheet(
                for: refundTarget?.refundableTransactionID ?? 0,
                isPresented: $isRefundSheetPresented
            ) { result in
                guard let row = refundTarget else { return }
                refundTarget = nil
                Task { await finishRefund(of: row, result: result) }
            }
            .manageSubscriptionsSheet(isPresented: $isManagingSubscriptions)
            .confirmationDialog(
                "Start as a new RevenueCat user?",
                isPresented: $isConfirmingNewUser,
                titleVisibility: .visible
            ) {
                Button("Start as a new user") {
                    Task { await startAsNewRevenueCatUser() }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This device gets a new RevenueCat user with no history. Purchases still on this Apple Account come back to it: ignore or refund them.")
            }
            .task { await reload() }
        }

        // MARK: - Rows

        @ViewBuilder
        private var purchaseRows: some View {
            if let rows {
                if rows.isEmpty {
                    Text("No test purchase on this Apple Account.")
                        .foregroundStyle(.secondary)
                }
                ForEach(rows) { row in
                    purchaseRow(row)
                }
                if rows.contains(where: { $0.kind == .subscription }) {
                    Button {
                        isManagingSubscriptions = true
                    } label: {
                        Label("Turn Off Renewal", systemImage: "arrow.triangle.2.circlepath")
                    }
                    .buttonStyle(.debugSecondary)
                    .disabled(isWorking)
                }
            } else {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Reading test purchases…")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }

        private func purchaseRow(_ row: TestPurchaseRow) -> some View {
            VStack(alignment: .leading, spacing: 10) {
                Toggle(isOn: ignoreBinding(for: row.productID)) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(row.productID)
                            .font(.footnote)
                            .monospaced()
                            .bold()
                        Text(row.summary(isIgnored: ignoredProductIDs.contains(row.productID)))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(Color.debugAccent)
                .disabled(isWorking)
                .accessibilityHint("Ignores this purchase, so the app acts as a free user.")

                if row.refundableTransactionID != nil {
                    Button {
                        outcome = nil
                        refundTarget = row
                        isRefundSheetPresented = true
                    } label: {
                        Label("Refund to Remove It", systemImage: "arrow.uturn.backward")
                    }
                    .buttonStyle(.debugSecondary)
                    .disabled(isWorking)
                }
            }
            .padding(.vertical, 4)
        }

        private var revenueCatRow: some View {
            VStack(alignment: .leading, spacing: 10) {
                InfoLabel(
                    title: "RevenueCat User ID:",
                    value: revenueCatUserId.isEmpty ? "Not configured" : revenueCatUserId,
                    horizontal: false
                )
                if canStartAsNewUser {
                    Button {
                        isConfirmingNewUser = true
                    } label: {
                        Label("Start as a New RevenueCat User", systemImage: "person.crop.circle.badge.plus")
                    }
                    .buttonStyle(.debugSecondary)
                    .disabled(isWorking)
                } else if !revenueCatUserId.isEmpty {
                    Text("The app signed this user in: sign out from the app to change it.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }

        private func outcomeRow(_ outcome: Outcome) -> some View {
            Label {
                Text(outcome.text)
                    .font(.caption)
            } icon: {
                Image(systemName: outcome.isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundStyle(outcome.isSuccess ? .green : .orange)
            }
        }

        // MARK: - Actions

        private func ignoreBinding(for productID: String) -> Binding<Bool> {
            Binding(
                get: { ignoredProductIDs.contains(productID) },
                set: { ignores in
                    IgnoredTestPurchases.setIgnoring(ignores, productID: productID, notifies: false)
                    ignoredProductIDs = IgnoredTestPurchases.productIDs
                    DebugConsoleChanges.testPurchasesChanged = true
                    outcome = nil
                    onChange()
                }
            )
        }

        /// RevenueCat only logs out a signed-in user, so an anonymous one is replaced
        /// by signing in as a throwaway user, then logging out. A throwaway user left
        /// by an interrupted reset only needs the log out.
        private var canStartAsNewUser: Bool {
            revenueCatUserId.hasPrefix(Self.anonymousUserPrefix)
                || revenueCatUserId.hasPrefix(Self.throwawayUserPrefix)
        }

        private static let anonymousUserPrefix = "$RCAnonymousID:"
        private static let throwawayUserPrefix = "kovalee-test-reset-"

        @MainActor
        private func reload() async {
            ignoredProductIDs = IgnoredTestPurchases.productIDs
            let customerInfo = Purchases.isConfigured ? try? await Purchases.shared.customerInfo() : nil
            rows = TestPurchaseRow.rows(
                storeKit: await TestPurchase.current(),
                customerInfo: customerInfo,
                ignoredProductIDs: ignoredProductIDs
            )
            revenueCatUserId = Kovalee.revenueCatUserId()
        }

        @MainActor
        private func finishRefund(
            of row: TestPurchaseRow,
            result: Result<StoreKit.Transaction.RefundRequestStatus, StoreKit.Transaction.RefundRequestError>
        ) async {
            switch result {
            case .success(.userCancelled):
                return
            case let .failure(error):
                outcome = .failure("Apple didn't take the refund request: \(error.localizedDescription)")
                return
            default:
                break
            }

            // The sheet can report success though nothing was sent (it sometimes only
            // says “Cannot Connect”), so check that the purchase is really gone.
            isWorking = true
            defer { isWorking = false }
            let isRemoved = await TestPurchase.waitUntilRemoved(productID: row.productID)
            // Tell RevenueCat now rather than whenever it next looks.
            _ = try? await Kovalee.syncPurchases()
            DebugConsoleChanges.testPurchasesChanged = true
            await reload()
            onChange()

            outcome = isRemoved
                ? .success("\(row.productID) is refunded. Close this console: the app acts as a free user and can buy it again.")
                : .failure("Apple hasn't removed \(row.productID) yet. If its sheet said “Cannot Connect”, the request didn't go through: try again, or ignore the purchase instead.")
        }

        @MainActor
        private func startAsNewRevenueCatUser() async {
            outcome = nil
            isWorking = true
            defer { isWorking = false }
            do {
                if revenueCatUserId.hasPrefix(Self.anonymousUserPrefix) {
                    _ = try await Kovalee.setRevenueCatUserId(
                        userId: Self.throwawayUserPrefix + UUID().uuidString.lowercased()
                    )
                }
                _ = try await Kovalee.logoutRevenueCatUser()
                outcome = .success("New RevenueCat user. Restart the app so everything starts from it.")
            } catch {
                outcome = .failure("Couldn't start a new RevenueCat user: \(error.localizedDescription)")
            }
            DebugConsoleChanges.testPurchasesChanged = true
            await reload()
            onChange()
        }
    }

    /// What the debug console changed that the app has to hear about once the console
    /// closes.
    @MainActor
    enum DebugConsoleChanges {
        static var testPurchasesChanged = false

        /// Posts ``IgnoredTestPurchases/didChangeNotification`` if test purchases
        /// changed while the console was open.
        static func postIfNeeded() {
            guard testPurchasesChanged else { return }
            testPurchasesChanged = false
            NotificationCenter.default.post(name: IgnoredTestPurchases.didChangeNotification, object: nil)
        }
    }

    @available(iOS 16.0, *)
    private struct Outcome {
        let text: String
        let isSuccess: Bool

        static func success(_ text: String) -> Outcome { Outcome(text: text, isSuccess: true) }
        static func failure(_ text: String) -> Outcome { Outcome(text: text, isSuccess: false) }
    }

    /// One product the tester bought in a test environment, as StoreKit and RevenueCat
    /// see it, or that is ignored.
    @available(iOS 16.0, *)
    struct TestPurchaseRow: Identifiable, Equatable {
        let productID: String
        let kind: TestPurchase.Kind?
        /// StoreKit's test transaction for it, what a refund is requested for.
        let refundableTransactionID: UInt64?

        var id: String { productID }

        func summary(isIgnored: Bool) -> String {
            let kindLabel = kind?.label ?? "Purchase"
            return isIgnored ? "\(kindLabel) · ignored" : kindLabel
        }

        /// The App Store sandbox purchases RevenueCat reports active, the StoreKit test
        /// purchases, and the ignored products, one row per product.
        static func rows(
            storeKit: [TestPurchase],
            customerInfo: CustomerInfo?,
            ignoredProductIDs: Set<String>
        ) -> [TestPurchaseRow] {
            var productIDs = Set(storeKit.map(\.productID)).union(ignoredProductIDs)
            if let customerInfo {
                for entitlement in customerInfo.entitlements.active.values
                where entitlement.isSandbox && entitlement.store == .appStore {
                    productIDs.insert(entitlement.productIdentifier)
                }
                for productID in customerInfo.activeSubscriptions {
                    guard let subscription = customerInfo.subscriptionsByProductIdentifier[productID],
                          subscription.isSandbox, subscription.store == .appStore
                    else { continue }
                    productIDs.insert(productID)
                }
            }
            return productIDs.sorted().map { productID in
                let transaction = storeKit.first { $0.productID == productID }
                let kind = transaction?.kind
                    ?? (customerInfo?.subscriptionsByProductIdentifier[productID] != nil ? .subscription : nil)
                return TestPurchaseRow(
                    productID: productID,
                    kind: kind,
                    refundableTransactionID: transaction?.id
                )
            }
        }
    }

    /// A purchase the device's Apple Account owns in a test environment: TestFlight or a
    /// Sandbox account (`Sandbox`), or an Xcode StoreKit configuration (`Xcode`).
    @available(iOS 16.0, *)
    struct TestPurchase: Identifiable, Equatable {
        enum Kind {
            case subscription
            case lifetime
            case nonRenewing

            var label: String {
                switch self {
                case .subscription: return "Subscription"
                case .lifetime: return "Lifetime"
                case .nonRenewing: return "Non-renewing"
                }
            }
        }

        /// The transaction id: what a refund request is made for.
        let id: UInt64
        let productID: String
        let kind: Kind

        init(_ transaction: StoreKit.Transaction) {
            id = transaction.id
            productID = transaction.productID
            switch transaction.productType {
            case .autoRenewable: kind = .subscription
            case .nonConsumable: kind = .lifetime
            default: kind = .nonRenewing
            }
        }

        /// What the Apple Account owns right now in test environments. Production
        /// purchases are left out, so a real purchase is never offered for a refund.
        static func current() async -> [TestPurchase] {
            var purchases: [TestPurchase] = []
            for await result in StoreKit.Transaction.currentEntitlements {
                guard case let .verified(transaction) = result,
                      transaction.environment != .production,
                      transaction.revocationDate == nil
                else { continue }
                purchases.append(TestPurchase(transaction))
            }
            return purchases
        }

        /// Waits up to about ten seconds for an approved refund to reach the device.
        static func waitUntilRemoved(productID: String) async -> Bool {
            for _ in 0 ..< 10 {
                if await !current().contains(where: { $0.productID == productID }) {
                    return true
                }
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            return false
        }
    }
#endif
