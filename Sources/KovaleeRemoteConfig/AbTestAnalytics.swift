import Foundation
import KovaleeFramework
import KovaleeSDK

#if canImport(FirebaseRemoteConfig)
    /// Reports the resolved AB test version to analytics as a tracking event.
    ///
    /// The AB test value can resolve through several entry points — remote fetch and
    /// debug overrides via ``Kovalee/abTestValue()``, and manual assignment via
    /// ``Kovalee/setAbTestValue(_:)``. Since ``Kovalee/abTestValue()`` may be called
    /// many times per launch, this actor dedupes so the event is only sent when the
    /// value actually changes (deduplication is in-memory, so the event fires at most
    /// once per launch for a stable value).
    actor AbTestAnalytics {
        static let shared = AbTestAnalytics()

        /// Name of the event sent when an AB test version is assigned.
        static let eventName = "ab_test_assigned"

        private var lastReportedValue: String?

        func report(value: String) {
            guard value != lastReportedValue else { return }
            lastReportedValue = value

            KLogger.debug("🧪 Reporting AB test assignment: \(value)")
            Kovalee.sendEvent(
                Event(name: Self.eventName, properties: [Kovalee.abTestKey: value])
            )
        }
    }
#endif
