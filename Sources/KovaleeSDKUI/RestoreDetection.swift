import Foundation
#if os(iOS)
    import RevenueCat

    /// RevenueCatUI fires `onRestoreCompleted` even when "Restore Purchases"
    /// recovered nothing. For a paywall shown to users who are *already* entitled —
    /// notably the subscription upsell, which is presented only to active
    /// trial/subscription users — `customerInfo.entitlements.active` is non-empty
    /// regardless, so checking it after the restore reports every no-op restore as a
    /// success and falsely emits `payment_restore`.
    ///
    /// The fix is to compare the entitlements active *before* the restore against
    /// those after: a restore recovered access only if it made an entitlement active
    /// that wasn't already active when it started. Both the generic paywall wrapper
    /// and the subscription upsell use this same predicate.
    enum RestoreDetection {
        /// Entitlement identifiers active right now, read synchronously from
        /// RevenueCat's cache. Capture this in `onRestoreStarted`, before the
        /// restore can change anything.
        static func activeEntitlementIDs() -> Set<String> {
            guard Purchases.isConfigured, let info = Purchases.shared.cachedCustomerInfo else {
                return []
            }
            return Set(info.entitlements.active.keys)
        }

        /// Whether a completed restore actually recovered access: some entitlement is
        /// active now that was not active in `before`.
        static func recoveredAccess(before: Set<String>, after: CustomerInfo) -> Bool {
            !Set(after.entitlements.active.keys).subtracting(before).isEmpty
        }
    }
#endif
