#if os(iOS) || os(visionOS)
    import KovaleePurchases
    import SwiftUI

    /// Debug and TestFlight builds only, while test purchases are ignored (see
    /// ``IgnoredTestPurchases``): a small badge at the top of the paywall that says why
    /// it shows to someone who has paid, and gives the purchases back. Buying again
    /// also ends ignoring a product, but StoreKit may report re-buying a product the
    /// tester still owns as a cancel, so the badge is the way out that always works.
    struct IgnoredTestPurchasesBadge: View {
        let onUseAgain: () -> Void

        @State private var count = IgnoredTestPurchases.productIDs.count
        @State private var isConfirming = false

        var body: some View {
            Group {
                if count > 0 {
                    Button {
                        isConfirming = true
                    } label: {
                        Label(title, systemImage: "hammer.fill")
                            .font(.caption2.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                    .confirmationDialog(
                        "Your test purchases are ignored",
                        isPresented: $isConfirming,
                        titleVisibility: .visible
                    ) {
                        Button("Use my purchases again") { onUseAgain() }
                        Button("Keep testing", role: .cancel) {}
                    } message: {
                        Text("The app acts as if you hadn't bought them, so you can test the paywall.")
                    }
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(for: IgnoredTestPurchases.didChangeNotification)
            ) { _ in
                count = IgnoredTestPurchases.productIDs.count
            }
        }

        private var title: String {
            count == 1 ? "TestFlight · 1 purchase ignored" : "TestFlight · \(count) purchases ignored"
        }
    }
#endif
