import Foundation
import KovaleeFramework
import KovaleeSDK

extension FacebookManagerCreator: Creator {
    public func createImplementation(
        withConfiguration _: Configuration,
        andKeys _: KovaleeKeys
    ) -> Manager {
        // App ID + Client Token are read from the host app's Info.plist
        // (`FacebookAppID` / `FacebookClientToken`) — no KovaleeKeys entry needed.
        let wrapper = FacebookWrapperImpl()
        KovaleeDebugIntegrations.shared.register(KovaleeDebugIntegration(
            id: "facebook",
            title: "Facebook (Meta)",
            fields: { FacebookWrapperRef.shared.wrapper?.debugFields() ?? [] },
            actions: [
                KovaleeDebugIntegrationAction("Send test event") {
                    FacebookWrapperRef.shared.wrapper?.logEvent(
                        "kovalee_debug_ping",
                        parameters: ["source": "debug_menu"]
                    )
                    FacebookWrapperRef.shared.wrapper?.flush()
                },
                KovaleeDebugIntegrationAction("Flush events") {
                    FacebookWrapperRef.shared.wrapper?.flush()
                },
            ]
        ))
        return wrapper
    }
}

// MARK: Facebook

public extension Kovalee {
    /// Track a standard Facebook `Purchase` event.
    ///
    /// - Warning: The SDK's automatic purchase dispatch deliberately does NOT fire
    ///   the standard `Purchase`/`StartTrial` events — Adjust is the MMP of record
    ///   and owns the iOS attribution slot for them (RevenueCat → Adjust → Meta).
    ///   Purchases made through `Kovalee.purchase(package:fromSource:)` /
    ///   `Kovalee.purchaseSubscription(withId:fromSource:)` fire only the granular
    ///   `purchase_<period>[_trial]` custom event. Only call this manually if you
    ///   knowingly want an SDK-side standard `Purchase` on top of Adjust's feed.
    ///
    /// Safe to call in apps that do not link KovaleeFacebook — the call is a no-op.
    ///
    /// - Parameters:
    ///   - amount: purchase amount in the given currency
    ///   - currency: ISO 4217 currency code (e.g. "USD")
    ///   - parameters: optional extra parameters attached to the event
    static func trackFacebookPurchase(
        amount: Double,
        currency: String,
        parameters: [String: String]? = nil
    ) {
        FacebookWrapperRef.shared.wrapper?.logPurchase(
            amount: amount,
            currency: currency,
            parameters: parameters
        )
    }

    /// Track a custom Facebook App Event.
    ///
    /// Safe to call in apps that do not link KovaleeFacebook — the call is a no-op.
    ///
    /// - Parameters:
    ///   - name: the event name
    ///   - parameters: optional dictionary of parameters to attach to the event
    static func trackFacebookEvent(
        _ name: String,
        parameters: [String: String]? = nil
    ) {
        FacebookWrapperRef.shared.wrapper?.logEvent(name, parameters: parameters)
    }

    /// Enable or disable Facebook advertiser tracking.
    ///
    /// Pass the user's ATT consent so Meta can attribute value; when disabled,
    /// events fall back to SKAdNetwork-only measurement.
    ///
    /// Safe to call in apps that do not link KovaleeFacebook — the call is a no-op.
    ///
    /// - Parameter enabled: whether advertiser tracking should be enabled
    static func setFacebookAdvertiserTrackingEnabled(_ enabled: Bool) {
        FacebookWrapperRef.shared.wrapper?.setAdvertiserTrackingEnabled(enabled)
    }

    /// Explicitly flush any queued Facebook events.
    static func flushFacebookEvents() {
        FacebookWrapperRef.shared.wrapper?.flush()
    }
}
