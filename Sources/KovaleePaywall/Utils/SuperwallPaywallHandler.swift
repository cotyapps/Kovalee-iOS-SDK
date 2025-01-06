import KovaleeFramework
import KovaleeSDK
import SuperwallKit

class SuperwallPaywallHandler {
    private init() {}

    static let shared = SuperwallPaywallHandler()
    var onComplete: ((PaywallPresentationError?) -> Void)?

    func retrievePaywall(
        event: String,
        params: [String: Any]?
    ) async throws -> PaywallViewController {
        do {
            let triggerEvent = await Kovalee.paywallTriggerEventFromABTest() ?? event
            var userParams = params ?? [String: Any]()
            userParams["event_name"] = triggerEvent
            Superwall.shared.setUserAttributes(userParams)
            return try await Superwall.shared.getPaywall(
                forEvent: triggerEvent,
                params: userParams,
                delegate: self
            )

            /// In case the event retrieved by the AB test has no paywalls associated
            /// retrieve the paywall associated to the default event
        } catch PaywallSkippedReason.eventNotFound {
            return try await Superwall.shared.getPaywall(
                forEvent: event,
                params: params,
                delegate: self
            )
        } catch {
            throw error
        }
    }
}

extension SuperwallPaywallHandler: PaywallViewControllerDelegate {
    func paywall(
        _: SuperwallKit.PaywallViewController,
        didFinishWith _: SuperwallKit.PaywallResult,
        shouldDismiss dismiss: Bool
    ) {
        guard dismiss else {
            return
        }

        onComplete?(nil)
    }
}
