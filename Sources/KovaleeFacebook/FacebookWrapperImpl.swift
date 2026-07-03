import Foundation
import KovaleeFramework
import KovaleeSDK

#if canImport(AppTrackingTransparency)
    import AppTrackingTransparency
#endif

/// Holds a reference to the active Facebook wrapper for use by public API methods.
final class FacebookWrapperRef: @unchecked Sendable {
    static let shared = FacebookWrapperRef()

    private let lock = NSLock()
    private var _wrapper: FacebookWrapperImpl?

    var wrapper: FacebookWrapperImpl? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _wrapper
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _wrapper = newValue
        }
    }
}

#if os(iOS)
    import FBSDKCoreKit

    final class FacebookWrapperImpl: Manager, FacebookManager {
        /// `false` when the module is linked but the host app's Info.plist is missing a
        /// `FacebookAppID` or `FacebookClientToken` — every tracking call then becomes a
        /// no-op instead of tripping the Facebook SDK's missing-configuration assertion.
        /// Both keys are required: the SDK reads them from the plist during
        /// `initializeSDK()`, so guarding on the app id alone still crashes/degrades when
        /// only the client token is absent.
        private let isConfigured: Bool

        private let lock = NSLock()
        // All below are lock-guarded.
        private var dataCollectionEnabled = false
        /// `true` once any explicit `setDataCollectionEnabled` decision arrived (from
        /// hydration or the runtime toggle). Before that, consent is *unknown*: events
        /// are held locally in `pendingEvents` (nothing leaves the device) rather than
        /// dropped, so launch-time events survive the hydration window.
        private var consentResolved = false
        private var activationInFlight = false
        private var didActivate = false
        /// Last ATT decision delivered via `setAdvertiserTrackingEnabled`; `nil` until
        /// the prompt handler fires — then the live `ATTrackingManager` status is used.
        private var attAuthorized: Bool?
        /// Orders the async main-thread writes to `Settings.isAdvertiserTrackingEnabled`:
        /// every sync bumps it, and a queued write only lands if it is still the latest —
        /// otherwise a stale disable could clobber a newer enable (or vice versa).
        private var settingsGeneration = 0
        /// Events fired before activation (consent unknown or bring-up still in flight),
        /// replayed in order once the SDK is activated with consent granted.
        private var pendingEvents: [() -> Void] = []

        private static let pendingEventsCap = 50

        init() {
            let appID = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String
            let clientToken = Bundle.main.object(forInfoDictionaryKey: "FacebookClientToken") as? String
            guard let appID, !appID.isEmpty, let clientToken, !clientToken.isEmpty else {
                KLogger.error("KovaleeFacebook is linked but FacebookAppID/FacebookClientToken are missing from Info.plist — Facebook events are disabled")
                isConfigured = false
                FacebookWrapperRef.shared.wrapper = self
                return
            }

            isConfigured = true
            FacebookWrapperRef.shared.wrapper = self
        }

        // MARK: FacebookManager

        func logSubscriptionPurchase(
            productId: String,
            value: Double,
            currency: String,
            periodUnit: KPurchasePeriodUnit?,
            hasFreeTrial: Bool,
            transactionId: String?
        ) {
            performOrBuffer {
                Self.emitSubscriptionPurchase(
                    productId: productId,
                    value: value,
                    currency: currency,
                    periodUnit: periodUnit,
                    hasFreeTrial: hasFreeTrial,
                    transactionId: transactionId
                )
            }
        }

        func logPurchase(amount: Double, currency: String, parameters: [String: String]?) {
            performOrBuffer {
                AppEvents.shared.logPurchase(
                    amount: amount,
                    currency: currency,
                    parameters: Self.mapParameters(parameters)
                )
            }
        }

        func logEvent(_ name: String, parameters: [String: String]?) {
            performOrBuffer {
                AppEvents.shared.logEvent(AppEvents.Name(name), parameters: Self.mapParameters(parameters))
            }
        }

        func setAdvertiserTrackingEnabled(_ enabled: Bool) {
            guard isConfigured else { return }
            lock.lock()
            attAuthorized = enabled
            lock.unlock()
            syncAdvertiserTracking()
        }

        func setDataCollectionEnabled(_ enabled: Bool) {
            guard isConfigured else { return }

            let shouldActivate: Bool
            lock.lock()
            dataCollectionEnabled = enabled
            consentResolved = true
            if !enabled {
                // Explicit opt-out: buffered events must never be sent.
                pendingEvents.removeAll()
            }
            shouldActivate = enabled && !didActivate && !activationInFlight
            if shouldActivate {
                activationInFlight = true
            }
            lock.unlock()

            // Keep the advertiser-tracking flag consistent on EVERY transition — this is
            // what restores it after a disable→re-enable cycle (the activation block only
            // runs once per session).
            syncAdvertiserTracking()

            guard enabled else { return }

            guard shouldActivate else {
                // Already activated (or activation in flight): release anything buffered
                // while consent was still unknown.
                flushPendingEvents()
                return
            }

            KLogger.debug("initializing Facebook")
            // FBSDK bring-up (initializeSDK/activateApp) and Settings mutation are
            // main-thread-only; hop if Kovalee.initialize was called off the main thread.
            Self.onMain { [weak self] in
                guard let self, self.isDataCollectionEnabled else {
                    self?.completeActivation(didActivate: false)
                    return
                }

                ApplicationDelegate.shared.initializeSDK()
                self.syncAdvertiserTracking()
                AppEvents.shared.activateApp()
                self.completeActivation(didActivate: true)
            }
        }

        func flush() {
            guard canTrack else { return }
            AppEvents.shared.flush()
        }

        // MARK: State machine internals

        private var canTrack: Bool {
            guard isConfigured else { return false }
            lock.lock()
            defer { lock.unlock() }
            return dataCollectionEnabled && didActivate
        }

        private var isDataCollectionEnabled: Bool {
            lock.lock()
            defer { lock.unlock() }
            return dataCollectionEnabled
        }

        /// Runs the event now when the SDK is live, holds it for replay while consent is
        /// unknown or activation is in flight, and drops it after an explicit opt-out.
        private func performOrBuffer(_ work: @escaping () -> Void) {
            guard isConfigured else { return }
            lock.lock()
            if didActivate, dataCollectionEnabled {
                lock.unlock()
                work()
                return
            }
            if consentResolved, !dataCollectionEnabled {
                lock.unlock()
                return
            }
            if pendingEvents.count < Self.pendingEventsCap {
                pendingEvents.append(work)
                if pendingEvents.count == Self.pendingEventsCap {
                    KLogger.warn("Facebook pre-activation event buffer is full — further events will be dropped until activation")
                }
            }
            lock.unlock()
        }

        private func flushPendingEvents() {
            while true {
                lock.lock()
                guard didActivate, dataCollectionEnabled, !pendingEvents.isEmpty else {
                    lock.unlock()
                    return
                }
                let batch = pendingEvents
                pendingEvents.removeAll()
                lock.unlock()
                batch.forEach { $0() }
            }
        }

        private func completeActivation(didActivate activated: Bool) {
            lock.lock()
            activationInFlight = false
            didActivate = activated
            lock.unlock()
            if activated {
                flushPendingEvents()
            }
        }

        /// Recomputes `Settings.isAdvertiserTrackingEnabled` from the latest known state
        /// (stored ATT decision — or the live ATT status before the prompt handler ever
        /// fired — AND data-collection consent) and writes it on the main thread. The
        /// generation counter ensures a stale queued write never clobbers a newer one,
        /// whatever order the async blocks land in.
        private func syncAdvertiserTracking() {
            guard isConfigured else { return }
            lock.lock()
            settingsGeneration += 1
            let generation = settingsGeneration
            let enabled = dataCollectionEnabled
            let att = attAuthorized
            lock.unlock()

            Self.onMain { [weak self] in
                guard let self else { return }
                self.lock.lock()
                let isCurrent = (generation == self.settingsGeneration)
                self.lock.unlock()
                guard isCurrent else { return }

                let attAllowed: Bool
                #if canImport(AppTrackingTransparency)
                    attAllowed = att ?? (ATTrackingManager.trackingAuthorizationStatus == .authorized)
                #else
                    attAllowed = att ?? false
                #endif
                Settings.shared.isAdvertiserTrackingEnabled = attAllowed && enabled
            }
        }

        /// Runs `work` on the main thread — synchronously when already on it, else async.
        /// FBSDK bring-up and `Settings` mutation are documented as main-thread-only.
        private static func onMain(_ work: @escaping @Sendable () -> Void) {
            if Thread.isMainThread {
                work()
            } else {
                DispatchQueue.main.async(execute: work)
            }
        }

        // MARK: Event construction

        private static let subscriptionTypeParameter = AppEvents.ParameterName("subscription_type")
        private static let transactionIdParameter = AppEvents.ParameterName("transaction_id")

        private static func emitSubscriptionPurchase(
            productId: String,
            value: Double,
            currency: String,
            periodUnit: KPurchasePeriodUnit?,
            hasFreeTrial: Bool,
            transactionId: String?
        ) {
            let eventName = subscriptionEventName(periodUnit: periodUnit, hasFreeTrial: hasFreeTrial)

            var parameters: [AppEvents.ParameterName: Any] = [
                .contentID: productId,
                subscriptionTypeParameter: eventName,
            ]
            if let transactionId {
                parameters[transactionIdParameter] = transactionId
            }

            if hasFreeTrial {
                // No money is collected at a free-trial start, so we must NOT fire the
                // standard `Purchase` event with the recurring price — that would pollute
                // realized-revenue / Purchase-optimized (AEO) reporting with money that was
                // never charged. Use the standard `StartTrial` event instead; it carries the
                // subscription's value + currency (what Meta expects for trial optimization).
                var trialParameters = parameters
                trialParameters[.currency] = currency
                AppEvents.shared.logEvent(.startTrial, valueToSum: value, parameters: trialParameters)
            } else {
                // Real charge — the standard `Purchase` event carries the realized value Meta
                // uses for value optimization / AEO and standard purchase attribution.
                AppEvents.shared.logPurchase(amount: value, currency: currency, parameters: parameters)
            }

            // Granular custom event (e.g. `purchase_yearly_trial`) for reporting, custom
            // conversions and audiences. Intentionally carries NO value — the standard event
            // above owns the monetary value; attaching it here too would double-count it.
            AppEvents.shared.logEvent(AppEvents.Name(eventName), parameters: parameters)
        }

        /// Maps the subscription period + trial status onto Kovalee's custom event
        /// taxonomy: `purchase_yearly_trial`, `purchase_monthly_trial`,
        /// `purchase_monthly`, `purchase_yearly` (with `weekly`/`daily`/`unknown`
        /// fallbacks for non-standard periods).
        static func subscriptionEventName(periodUnit: KPurchasePeriodUnit?, hasFreeTrial: Bool) -> String {
            let period: String
            switch periodUnit {
            case .year: period = "yearly"
            case .month: period = "monthly"
            case .week: period = "weekly"
            case .day: period = "daily"
            case .none: period = "unknown"
            @unknown default: period = "unknown"
            }
            return hasFreeTrial ? "purchase_\(period)_trial" : "purchase_\(period)"
        }

        private static func mapParameters(_ parameters: [String: String]?) -> [AppEvents.ParameterName: Any] {
            guard let parameters else { return [:] }
            var mapped: [AppEvents.ParameterName: Any] = [:]
            for (key, value) in parameters {
                mapped[AppEvents.ParameterName(key)] = value
            }
            return mapped
        }
    }

    extension FacebookWrapperImpl: @unchecked Sendable {}
#else
    final class FacebookWrapperImpl: Manager, FacebookManager {
        init() {
            FacebookWrapperRef.shared.wrapper = self
        }

        func logSubscriptionPurchase(
            productId _: String,
            value _: Double,
            currency _: String,
            periodUnit _: KPurchasePeriodUnit?,
            hasFreeTrial _: Bool,
            transactionId _: String?
        ) {}
        func logPurchase(amount _: Double, currency _: String, parameters _: [String: String]?) {}
        func logEvent(_: String, parameters _: [String: String]?) {}
        func setAdvertiserTrackingEnabled(_: Bool) {}
        func setDataCollectionEnabled(_: Bool) {}
        func flush() {}
    }

    extension FacebookWrapperImpl: @unchecked Sendable {}
#endif
