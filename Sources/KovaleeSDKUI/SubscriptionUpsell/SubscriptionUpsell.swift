import Foundation
#if os(iOS)
import UIKit
import SwiftUI

/// Drives an "eligible subscription → upsell paywall → cancel-original-subscription" flow.
///
/// Host apps configure with the RevenueCat offering to present and the product
/// identifiers that count as the source subscription. The SDK then:
///
/// 1. Checks for an active entitlement matching the product identifiers that
///    `trigger` resolves to and satisfying `condition` — either a trial expiring
///    within a window, or a non-trial subscription active longer than an interval.
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

	/// Style for the post-purchase ("Lifetime unlocked" / cancel-prompt) screens.
	///
	/// Resolves to `KovaleeUI.configuration.style` — the single style
	/// partners already configure for the feedback sheets — so both surfaces
	/// match out of the box. Falls back to `.default` on iOS < 17, where
	/// `KovaleeUI.configuration` is unavailable. Per-call
	/// `Configuration.cancelPromptStyle` still takes precedence inside the real
	/// upsell flow.
	@MainActor
	static var defaultCancelPromptStyle: KovaleeUIStyle {
		if #available(iOS 17, *) {
			return KovaleeUI.configuration.style
		}
		return .default
	}


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

	/// What makes a matching entitlement eligible to trigger the upsell.
	public enum Condition: Sendable, Equatable {
		/// An active trial entitlement whose expiration is within the given window.
		case trialExpiring(within: TimeInterval)
		/// An active, non-trial subscription first purchased more than the given
		/// interval ago. Re-engages established subscribers — e.g. upselling a
		/// long-time yearly subscriber to lifetime.
		case activeLongerThan(TimeInterval)
	}

	public struct Configuration: Sendable {
		/// RevenueCat offering identifier rendered as the upsell paywall.
		public let offeringId: String

		/// Which source subscription(s) to watch. Scopes which products count
		/// toward `condition` (e.g. `.yearly` resolves to the annual products).
		public let trigger: Trigger

		/// Time window before trial expiration during which to trigger. Used as the
		/// default for the `.trialExpiring` condition when `condition` is omitted.
		public let triggerWithin: TimeInterval

		/// What makes a matching entitlement eligible to trigger the upsell.
		/// Defaults to `.trialExpiring(within: triggerWithin)` for backward
		/// compatibility with callers that only set `triggerWithin`.
		public let condition: Condition

		/// Namespace key used to remember "already shown" state. Reusing the
		/// same key across runs / sessions guarantees the flow shows once per
		/// install.
		public let storageKey: String

		/// Skip condition-detection and present the paywall as if a matching
		/// entitlement were found. The show-once gate still applies — once presented for
		/// this `storageKey` the flow won't run again until the flag is cleared
		/// via `SubscriptionUpsellOverride.clearAllShownStates()`. For QA /
		/// screenshots only — ship with `false`.
		public let debugForceTrigger: Bool

		/// Overlays a top-leading X close button on the paywall, independent of
		/// the RC paywall template. Leave `false` if your RC paywall already
		/// has a button with the close action designed into it. Enable when
		/// the paywall has no dismiss UI of its own.
		public let showCloseButton: Bool

		/// Per-flow override for the post-purchase screens' styling. When `nil`
		/// the orchestrator falls back to `KovaleeUI.configuration.style`
		/// so the upsell matches the feedback sheets. Pass an explicit
		/// `KovaleeUIStyle` to override just this flow.
		public let cancelPromptStyle: KovaleeUIStyle?

		public init(
			offeringId: String,
			trigger: Trigger,
			triggerWithin: TimeInterval = 48 * 3600,
			storageKey: String,
			condition: Condition? = nil,
			debugForceTrigger: Bool = false,
			showCloseButton: Bool = false,
			cancelPromptStyle: KovaleeUIStyle? = nil
		) {
			self.offeringId = offeringId
			self.trigger = trigger
			self.triggerWithin = triggerWithin
			self.storageKey = storageKey
			self.condition = condition ?? .trialExpiring(within: triggerWithin)
			self.debugForceTrigger = debugForceTrigger
			self.showCloseButton = showCloseButton
			self.cancelPromptStyle = cancelPromptStyle
		}

		/// Copy with a different RevenueCat offering, keeping every other field.
		/// Used by `handleDeepLink` to honor an `?offering=` override.
		public func overridingOffering(id: String) -> Configuration {
			Configuration(
				offeringId: id,
				trigger: trigger,
				triggerWithin: triggerWithin,
				storageKey: storageKey,
				condition: condition,
				debugForceTrigger: debugForceTrigger,
				showCloseButton: showCloseButton,
				cancelPromptStyle: cancelPromptStyle
			)
		}
	}

	public enum Outcome: Sendable, Equatable {
		case notTriggered
		case dismissed
		case purchased
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


	/// Force-presents the upsell paywall right now, bypassing condition detection
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
	/// purchase. Uses `KovaleeUI.configuration.style` unless overridden.
	@MainActor
	public static func presentCongratsScreen(
		style: KovaleeUIStyle? = nil,
		onCompletion: (@MainActor @Sendable () -> Void)? = nil
	) {
		UpsellPostPurchaseView.launchAtTop(style: style ?? defaultCancelPromptStyle) {
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
	/// An optional `?offering=<id>` query item overrides
	/// `configuration.offeringId`, so a single deep link can target any paywall
	/// (e.g. `<scheme>://upsell?offering=Default_2` for a harder-discount
	/// offering sent by email). Every other configuration field is preserved.
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
		let resolved = offeringOverride(in: url).map(configuration.overridingOffering) ?? configuration
		presentNow(configuration: resolved, from: presenter, onCompletion: onCompletion)
		return true
	}


	/// Reads `?offering=<id>` from a deep link, trimming whitespace and the
	/// surrounding quotes that hand-authored marketing links sometimes carry.
	private static func offeringOverride(in url: URL) -> String? {
		guard let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else { return nil }
		guard let raw = items.first(where: { $0.name == "offering" })?.value else { return nil }
		let trimmed = raw.trimmingCharacters(in: CharacterSet(charactersIn: "\"").union(.whitespacesAndNewlines))
		return trimmed.isEmpty ? nil : trimmed
	}
}
#endif
