import Foundation
#if os(iOS)
    import KovaleeFramework
    import KovaleePurchases
    import KovaleeSDK
    import RevenueCat
    import RevenueCatUI
    import SwiftUI

    // MARK: - Conversion mapping

    /// Maps a purchased RevenueCat package onto the SDK's unified purchase-conversion
    /// dispatch (TikTok + Firebase revenue). Shared by the paywall wrapper
    /// and the subscription-upsell presenter so both fire identical conversions.
    enum PaywallConversionTracker {
        static func duration(_ package: Package) -> KovaleeSDK.Duration {
            switch package.storeProduct.subscriptionPeriod?.unit {
            case .day?: return .day
            case .week?: return .week
            case .month?: return .month
            default: return .year
            }
        }

        /// Fires the value-carrying conversion dispatch (TikTok + Firebase)
        /// for a completed purchase. Delegates to the canonical package→conversion
        /// mapping in KovaleePurchases; the transaction (when available) supplies the
        /// GA4 dedup id and the transaction-level free-trial truth.
        @MainActor
        static func track(package: Package, transaction: StoreTransaction? = nil) {
            Kovalee.trackSubscriptionConversion(package: package, transaction: transaction)
        }
    }

    // MARK: - Paywall wrapper

    /// Reference capture so the value-type purchase callbacks can share the package
    /// observed at purchase-start (needed to fire value-carrying conversions on
    /// completion — RevenueCatUI's `onPurchaseCompleted` gives only `CustomerInfo`).
    @MainActor
    private final class KovaleePaywallSignal {
        var purchasedPackage: Package?
        var didPurchase = false
        /// Entitlements active when a restore started, so completion can tell a real
        /// recovery from a no-op restore (see RestoreDetection).
        var entitlementsBeforeRestore: Set<String> = []

        func reset() {
            purchasedPackage = nil
            didPurchase = false
            entitlementsBeforeRestore = []
        }
    }

    private struct KovaleePaywallModifier: ViewModifier {
        @Binding var isPresented: Bool
        let offering: Offering?
        let source: String
        let onPurchaseCompleted: ((CustomerInfo) -> Void)?
        let onDismiss: ((Bool) -> Void)?

        @State private var signal = KovaleePaywallSignal()

        func body(content: Content) -> some View {
            content.fullScreenCover(
                isPresented: $isPresented,
                onDismiss: {
                    onDismiss?(signal.didPurchase)
                    // Clear immediately so a callback straggling in after dismissal can
                    // never read the previous presentation's package/outcome.
                    signal.reset()
                }
            ) {
                paywall
            }
        }

        @ViewBuilder
        private var paywall: some View {
            Group {
                if let offering {
                    PaywallView(offering: offering)
                } else {
                    PaywallView()
                }
            }
            .onAppear {
                signal.reset()
                Kovalee.sendEvent(event: BasicEvent.pageViewPaywall(source: source))
            }
            .onPurchaseStarted { package in
                signal.purchasedPackage = package
                Kovalee.startedPurchasing(
                    subscriptionWithProductId: package.storeProduct.productIdentifier,
                    fromSource: source
                )
            }
            .onPurchaseCompleted { (transaction: StoreTransaction?, customerInfo: CustomerInfo) in
                signal.didPurchase = true
                if let package = signal.purchasedPackage {
                    Kovalee.succesfullyPurchased(
                        subscriptionWithProductId: package.storeProduct.productIdentifier,
                        andDuration: PaywallConversionTracker.duration(package),
                        fromSource: source
                    )
                    // The gap this whole wrapper exists to close: value-carrying
                    // conversions (TikTok + Firebase) on a remote paywall.
                    PaywallConversionTracker.track(package: package, transaction: transaction)
                } else {
                    // Purchase completed without an observed start (external/custom flow):
                    // fire a best-effort finish and leave a trace — a silently missing
                    // conversion is otherwise undiagnosable.
                    let productId = transaction?.productIdentifier ?? customerInfo.activeSubscriptions.first
                    if let productId {
                        Kovalee.succesfullyPurchased(
                            subscriptionWithProductId: productId,
                            andDuration: .year,
                            fromSource: source
                        )
                    }
                    KLogger.warn("KovaleePaywall: purchase completed without a captured package — conversion skipped for \(productId ?? "unknown product")")
                }
                onPurchaseCompleted?(customerInfo)
                isPresented = false
            }
            .onPurchaseCancelled {
                Kovalee.paymentCancelledForSubscription(fromSource: source)
            }
            .onPurchaseFailure { _ in
                if let package = signal.purchasedPackage {
                    Kovalee.paymentFailed(
                        forSubscriptionWithId: package.storeProduct.productIdentifier,
                        fromSource: source
                    )
                }
            }
            .onRestoreStarted {
                signal.entitlementsBeforeRestore = RestoreDetection.activeEntitlementIDs()
                Kovalee.paymentRestoreStart(fromSource: source)
            }
            .onRestoreCompleted { customerInfo in
                // RevenueCatUI fires this callback even when there was nothing to
                // restore — only report a successful restore (and unlock + dismiss)
                // when the restore made an entitlement active that wasn't active
                // before it started (a post-restore emptiness check would report
                // every no-op restore as success for already-entitled users).
                if RestoreDetection.recoveredAccess(before: signal.entitlementsBeforeRestore, after: customerInfo) {
                    Kovalee.paymentRestored(fromSource: source)
                    signal.didPurchase = true
                    isPresented = false
                } else {
                    KLogger.debug("KovaleePaywall: restore recovered no new entitlement — payment_restore not fired")
                }
            }
            .onRestoreFailure { _ in
                Kovalee.paymentRestoredFailed(fromSource: source)
            }
            .onRequestedDismissal {
                isPresented = false
            }
        }
    }

    public extension View {
        /// Presents the app's RevenueCat paywall and fires **all** Kovalee purchase
        /// tracking automatically: `page_view_paywall`, `payment_start`/`finish`/
        /// `cancel`/`failure`/`restore` (incl. restore failure), **and the
        /// value-carrying conversion dispatch (TikTok + Firebase
        /// `purchase`)**.
        ///
        /// Use this instead of hand-wiring RevenueCatUI's `presentPaywallIfNeeded` /
        /// `PaywallView`, so remote-paywall purchases fire conversions exactly like
        /// native `Kovalee.purchase()` does. Gate `isPresented` on `!isUserPremium`
        /// at the call site as before.
        ///
        /// A successful restore that recovers an entitlement dismisses the paywall and
        /// reports `true` to `onDismiss`, same as a purchase.
        ///
        /// - Important: The wrapper already fires the conversion dispatch. Do NOT also
        ///   call `Kovalee.trackSubscriptionConversion(package:transaction:)` from your
        ///   `onPurchaseCompleted` — that would double-count the purchase on every ad
        ///   platform.
        ///
        /// - Parameters:
        ///   - isPresented: binding that shows/hides the paywall
        ///   - offering: explicit offering to render; `nil` uses the current offering
        ///   - source: analytics source (e.g. "progress", "onboarding")
        ///   - onPurchaseCompleted: optional hook after a successful purchase
        ///   - onDismiss: optional hook when the paywall dismisses; `Bool` = unlocked
        ///     (purchased or restored)
        func kovaleePaywall(
            isPresented: Binding<Bool>,
            offering: Offering? = nil,
            source: String,
            onPurchaseCompleted: ((CustomerInfo) -> Void)? = nil,
            onDismiss: ((Bool) -> Void)? = nil
        ) -> some View {
            modifier(KovaleePaywallModifier(
                isPresented: isPresented,
                offering: offering,
                source: source,
                onPurchaseCompleted: onPurchaseCompleted,
                onDismiss: onDismiss
            ))
        }
    }
#endif
