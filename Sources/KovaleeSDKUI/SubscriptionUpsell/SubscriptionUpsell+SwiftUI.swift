import Foundation
#if os(iOS)
import SwiftUI
import UIKit

public extension View {

	/// Runs the SubscriptionUpsell check when the view appears (and again on
	/// each foreground), idempotent via the configuration's storage key.
	///
	/// SwiftUI counterpart to ``SubscriptionUpsell/checkAndPresentIfNeeded(configuration:from:onCompletion:)``.
	func checkSubscriptionUpsell(
		configuration: SubscriptionUpsell.Configuration,
		onCompletion: (@MainActor @Sendable (SubscriptionUpsell.Outcome) -> Void)? = nil
	) -> some View {
		modifier(SubscriptionUpsellModifier(configuration: configuration, onCompletion: onCompletion))
	}
}


private struct SubscriptionUpsellModifier: ViewModifier {
	let configuration: SubscriptionUpsell.Configuration
	let onCompletion: (@MainActor @Sendable (SubscriptionUpsell.Outcome) -> Void)?

	@Environment(\.scenePhase) private var scenePhase

	func body(content: Content) -> some View {
		content
			.task(id: scenePhase) {
				if scenePhase == .active {
					runCheck()
				}
			}
	}


	@MainActor
	private func runCheck() {
		SubscriptionUpsellPresenter.run(
			configuration: configuration,
			present: { viewController in
				guard let presenter = SubscriptionUpsellModifier.topPresenter else { return false }
				presenter.present(viewController, animated: true)
				return true
			},
			onCompletion: onCompletion
		)
	}


	@MainActor
	private static var topPresenter: UIViewController? {
		let scene = UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first { $0.activationState == .foregroundActive }
		guard let root = scene?.keyWindow?.rootViewController else { return nil }
		var top = root
		while let presented = top.presentedViewController {
			top = presented
		}
		return top
	}
}
#endif
