import Foundation
#if os(iOS)
import UIKit

/// Resolves the top-most view controller to present from, so the upsell flow
/// (SwiftUI modifier, post-purchase screens, debug menu) doesn't need a
/// `UIViewController` handle threaded through.
enum TopPresenter {

	/// The frontmost presented controller of the active foreground scene, falling
	/// back to any connected window scene when none is `.foregroundActive`.
	@MainActor
	static var current: UIViewController? {
		let scenes = UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
		let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
		guard let root = scene?.keyWindow?.rootViewController else { return nil }
		var top = root
		while let presented = top.presentedViewController {
			top = presented
		}
		return top
	}
}
#endif
