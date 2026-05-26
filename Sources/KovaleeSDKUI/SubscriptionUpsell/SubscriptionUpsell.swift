import Foundation
#if os(iOS)
import UIKit
import SwiftUI

/// Drives a "trial-ending → upsell paywall → cancel-original-subscription" flow.
///
/// Host apps configure with the RevenueCat offering to present and the product
/// identifiers that count as the source subscription. The SDK then:
///
/// 1. Checks for an active trial entitlement matching `triggerProductIdentifiers`
///    whose expiration is within `triggerWithin`.
/// 2. Verifies the flow hasn't been shown before (idempotent per `storageKey`).
/// 3. Presents the RC-hosted paywall for `offeringId`.
/// 4. On successful purchase, presents a screen that opens Apple's
///    manage-subscriptions sheet so the user can turn off auto-renewal on the
///    original subscription (Apple does not allow developer-side cancellation).
///
/// The host app never sees subscription state, paywall internals, or the
/// manage-subscriptions sheet — it provides configuration and (optionally)
/// receives the final outcome.
public enum SubscriptionUpsell {

	/// Theme used by `presentCongratsScreen` and by the SDK debug-menu preview.
	/// Hosts can override at launch (e.g. `SubscriptionUpsell.defaultCancelPromptTheme = .pep`)
	/// so QA sees the production look-and-feel in previews. Per-call Configuration
	/// theme still takes precedence inside the real upsell flow.
	@MainActor
	public static var defaultCancelPromptTheme: Theme = .default


	/// Which source subscription(s) to watch. The SDK resolves the actual
	/// product identifiers from RC's offerings at evaluation time.
	public enum Trigger: Sendable, Equatable {
		/// Any annual subscription discovered in RC offerings.
		case yearly
		/// Any monthly subscription.
		case monthly
		/// Any weekly subscription.
		case weekly
		/// Any subscription regardless of period.
		case anySubscription
		/// Explicit product identifiers. Use when you need to scope to specific
		/// product IDs rather than a period bucket.
		case productIdentifiers(Set<String>)
	}

	public struct Configuration: Sendable {
		/// RevenueCat offering identifier rendered as the upsell paywall.
		public let offeringId: String

		/// Which source subscription(s) to watch for an expiring trial.
		public let trigger: Trigger

		/// Time window before trial expiration during which to trigger.
		public let triggerWithin: TimeInterval

		/// Namespace key used to remember "already shown" state. Reusing the
		/// same key across runs / sessions guarantees the flow shows once per
		/// install.
		public let storageKey: String

		/// Skip the trial-detection and show-once checks and present the paywall
		/// unconditionally. For QA / screenshots only — ship with `false`.
		public let debugForceTrigger: Bool

		/// Overlays a top-leading X close button on the paywall, independent of
		/// the RC paywall template. Leave `false` if your RC paywall already
		/// has a button with the close action designed into it. Enable when
		/// the paywall has no dismiss UI of its own.
		public let showCloseButton: Bool

		/// Visual customization for the post-purchase "Lifetime unlocked"
		/// screen. When `nil` the orchestrator falls back to
		/// `SubscriptionUpsell.defaultCancelPromptTheme` (which hosts can
		/// register once at launch). Pass an explicit `Theme` to override.
		public let cancelPromptTheme: Theme?

		public init(
			offeringId: String,
			trigger: Trigger,
			triggerWithin: TimeInterval = 48 * 3600,
			storageKey: String,
			debugForceTrigger: Bool = false,
			showCloseButton: Bool = false,
			cancelPromptTheme: Theme? = nil
		) {
			self.offeringId = offeringId
			self.trigger = trigger
			self.triggerWithin = triggerWithin
			self.storageKey = storageKey
			self.debugForceTrigger = debugForceTrigger
			self.showCloseButton = showCloseButton
			self.cancelPromptTheme = cancelPromptTheme
		}
	}

	public enum Outcome: Sendable, Equatable {
		case notTriggered
		case dismissed
		case purchased
	}


	/// Visual customization for the post-purchase "Lifetime unlocked" screen.
	/// Defaults to system styling so any host gets a sensible look without
	/// configuration.
	public struct Theme: Sendable {
		public var background: Color
		public var iconTint: Color
		public var titleColor: Color
		public var bodyColor: Color
		public var primaryButtonBackground: Color
		public var primaryButtonForeground: Color
		public var secondaryButtonColor: Color
		public var titleFont: Font
		public var bodyFont: Font
		public var buttonFont: Font
		/// SF Symbol shown above the "Lifetime unlocked" confirmation step.
		public var iconSystemName: String
		/// SF Symbol shown above the "One last step" cancel-prompt step. Kept
		/// separate from `iconSystemName` so the celebratory icon doesn't carry
		/// over into the more cautionary "turn off auto-renewal" screen.
		public var cancelPromptIconSystemName: String

		public init(
			background: Color = Color(.systemBackground),
			iconTint: Color = .accentColor,
			titleColor: Color = .primary,
			bodyColor: Color = .secondary,
			primaryButtonBackground: Color = .accentColor,
			primaryButtonForeground: Color = .white,
			secondaryButtonColor: Color = .secondary,
			titleFont: Font = .system(size: 32, weight: .semibold),
			bodyFont: Font = .body,
			buttonFont: Font = .headline,
			iconSystemName: String = "checkmark.seal.fill",
			cancelPromptIconSystemName: String = "exclamationmark.circle.fill"
		) {
			self.background = background
			self.iconTint = iconTint
			self.titleColor = titleColor
			self.bodyColor = bodyColor
			self.primaryButtonBackground = primaryButtonBackground
			self.primaryButtonForeground = primaryButtonForeground
			self.secondaryButtonColor = secondaryButtonColor
			self.titleFont = titleFont
			self.bodyFont = bodyFont
			self.buttonFont = buttonFont
			self.iconSystemName = iconSystemName
			self.cancelPromptIconSystemName = cancelPromptIconSystemName
		}

		public static let `default` = Theme()
	}

	/// UIKit entry point.
	///
	/// Idempotent: safe to call repeatedly (e.g. from every foreground). The
	/// flow runs at most once per `configuration.storageKey`.
	@MainActor
	public static func checkAndPresentIfNeeded(
		configuration: Configuration,
		from presenter: UIViewController,
		onCompletion: (@MainActor @Sendable (Outcome) -> Void)? = nil
	) {
		SubscriptionUpsellPresenter.run(
			configuration: configuration,
			present: { [weak presenter] viewController in
				guard let presenter else { return false }
				presenter.present(viewController, animated: true)
				return true
			},
			onCompletion: onCompletion
		)
	}


	/// Force-presents the upsell paywall right now, bypassing trial detection
	/// and the show-once gate. For deep links (e.g. `peptalk://upsell`) and
	/// marketing re-engagement.
	@MainActor
	public static func presentNow(
		configuration: Configuration,
		from presenter: UIViewController,
		onCompletion: (@MainActor @Sendable (Outcome) -> Void)? = nil
	) {
		SubscriptionUpsellPresenter.runForced(
			configuration: configuration,
			present: { [weak presenter] viewController in
				guard let presenter else { return false }
				presenter.present(viewController, animated: true)
				return true
			},
			onCompletion: onCompletion
		)
	}


	/// Presents the "Lifetime unlocked" congrats screen directly. Useful for
	/// debug menu previews, design reviews, and QA without needing a real
	/// purchase. Uses `defaultCancelPromptTheme` unless overridden.
	@MainActor
	public static func presentCongratsScreen(
		theme: Theme? = nil,
		onCompletion: (@MainActor @Sendable () -> Void)? = nil
	) {
		LifetimeCancelYearlyView.launchAtTop(theme: theme ?? defaultCancelPromptTheme) {
			onCompletion?()
		}
	}


	/// Routes `<scheme>://upsell` deep links to the upsell flow. Scheme-agnostic
	/// for custom schemes — matches on host/path so each host app can keep its
	/// own URL scheme.
	///
	/// ### What matches
	/// - `<scheme>://upsell`
	/// - `<scheme>://upsell/`
	/// - `<scheme>:///upsell` (hostless variant — path-only)
	///
	/// ### What does NOT match
	/// - `<scheme>://app/upsell` — `upsell` must be the host (or be the entire
	///   path in the hostless variant), not nested under another host.
	/// - `<scheme>://upsell/foo` — extra path segments are rejected.
	/// - `http://...` / `https://...` — refused so universal links with an
	///   unrelated `/upsell` path don't accidentally trigger the paywall.
	///
	/// - Returns: `true` if the URL was matched and the paywall is being
	///            presented, so the caller can short-circuit its other
	///            deep-link handlers.
	@MainActor
	public static func handleDeepLink(
		_ url: URL,
		configuration: Configuration,
		from presenter: UIViewController,
		onCompletion: (@MainActor @Sendable (Outcome) -> Void)? = nil
	) -> Bool {
		let scheme = url.scheme?.lowercased() ?? ""
		guard !scheme.isEmpty, scheme != "http", scheme != "https" else { return false }
		let hostIsUpsell = url.host == "upsell" && (url.path.isEmpty || url.path == "/")
		let hostlessUpsellPath = (url.host?.isEmpty ?? true) && url.path == "/upsell"
		guard hostIsUpsell || hostlessUpsellPath else { return false }
		presentNow(configuration: configuration, from: presenter, onCompletion: onCompletion)
		return true
	}
}
#endif
