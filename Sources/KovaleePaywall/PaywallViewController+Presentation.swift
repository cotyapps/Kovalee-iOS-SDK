import UIKit

/// An extension on `UIViewController` to present a full-screen paywall view controller.
///
/// This function presents a `KPaywallViewController` as a full-screen modal view. It initializes the paywall with necessary parameters such as the trigger event, source, and additional parameters. It also handles the completion of the paywall interaction.
///
/// Use this extension to easily present a paywall from any view controller in a full-screen format with the specified configuration.
///
/// ```swift
/// class ExampleViewController: UIViewController {
///     func showPaywall() {
///         presentFullScreenPaywallViewController(
///             trigger: "user_trial_ended",
///             params: ["user_id": "12345"],
///             alternativePaywall: AlternativePaywallViewController(variant: "0002")
///             onComplete: {
///                 print("Paywall dismissed")
///             }
///         )
///     }
/// }
/// ```
public extension UIViewController {
    /// Presents a full screen paywall on top of the current view controller.
    ///
    /// This method creates an instance of `KPaywallViewController`, configures it with provided parameters, and presents it in full-screen mode.
    /// Upon completion of the paywall interaction, it dismisses the paywall and executes the `onComplete` closure, if provided.
    ///
    /// - Parameters:
    ///   - event: The event trigger for showing the paywall. It refers to the event_name in Superwall.
    ///   - params: Optional parameters to send to Superwall for filtering audiences.
    ///   - alternativePaywall: Optional View Controller to be displayed in case the designated paywall can't be presented.
    ///   - onComplete: A closure called when the paywall should been dismissed, you are in charge of dismissing it. Returns the current ViewController so it can be dismissed and an optional presentation error in case of issues displaying the designated paywall.
    func presentFullScreenPaywallViewController(
        trigger: String,
        params: [String: Any]? = nil,
        alternativePaywall: AlternativePaywallController? = nil,
        onComplete: @escaping (UIViewController, PaywallPresentationError?) -> Void
    ) {
        let paywallViewController = KPaywallViewController(
            event: trigger,
            params: params,
            alternativePaywall: alternativePaywall,
            onComplete: onComplete
        )

        paywallViewController.modalPresentationStyle = .fullScreen
        present(paywallViewController, animated: true, completion: nil)
    }
}
