#if os(iOS)
import Foundation
import SwiftUI

// Migration shims for the `KovaleeUIStyle` unification (feedback + subscription
// upsell now share one style type, configured via `KovaleeUI.configuration.style`).
// Keep partner code compiling for one release; remove in the next major.

// MARK: Feedback styling — pure renames

@available(*, unavailable, renamed: "KovaleeUIStyle")
public typealias FeedbackStyle = KovaleeUIStyle

@available(iOS 17, *)
public extension KovaleeUI.Configuration {
	@available(*, unavailable, renamed: "style")
	var feedbackStyle: KovaleeUIStyle {
		get { style }
		set { style = newValue }
	}
}

// MARK: Subscription upsell — `Theme` was replaced by `KovaleeUIStyle`
//
// `Theme` keeps working as an alias, and the old field-labelled initializer (in
// the `KovaleeUIStyle` extension below) keeps existing call sites compiling with
// a deprecation *warning* rather than a hard "extra arguments" error. Call sites
// should still migrate by hand to the `KovaleeUIStyle` field names
// (`background`→`backgroundColor`, `titleColor`→`primaryColor`,
// `primaryButtonBackground`→`ctaColor`, `iconSystemName`→`confirmationIcon`, …);
// remove the shim in the next major.

public extension SubscriptionUpsell {

	@available(*, deprecated, renamed: "KovaleeUIStyle")
	typealias Theme = KovaleeUIStyle

	@available(*, deprecated, renamed: "KovaleeUI.configuration.style")
	@MainActor
	static var defaultCancelPromptTheme: KovaleeUIStyle {
		get { defaultCancelPromptStyle }
		set {
			if #available(iOS 17, *) {
				KovaleeUI.configuration.style = newValue
			}
		}
	}

	@available(*, deprecated, renamed: "presentCongratsScreen(style:onCompletion:)")
	@MainActor
	static func presentCongratsScreen(
		theme: KovaleeUIStyle?,
		onCompletion: (@MainActor @Sendable () -> Void)? = nil
	) {
		presentCongratsScreen(style: theme, onCompletion: onCompletion)
	}
}

// The old `SubscriptionUpsell.Theme` initializer, surfaced against the unified
// `KovaleeUIStyle`. Marked `unavailable` (a hard *error*, not a warning) rather
// than `deprecated`: the field shapes changed — three of the old per-element
// colors were collapsed — so there is no automatic fix-it and a silent warning
// could ship a miscolored upsell. The error carries the exact migration:
//   • `iconTint`                → folded into `ctaColor` (the icon now uses the CTA accent)
//   • `primaryButtonForeground` → derived by the SDK from `ctaColor`'s luminance
//   • `secondaryButtonColor`    → folded into `secondaryColor`
//
// The init still exists (with a forwarding body) so the diagnostic is the clean
// message below instead of a cryptic "extra arguments at positions …" error.
// `@_disfavoredOverload` keeps the no-argument `KovaleeUIStyle()` resolving to the
// real initializer (so `KovaleeUIStyle.default` and the new field-labelled call
// sites stay unambiguous) — only the old labels below select this shim.
public extension KovaleeUIStyle {
	@_disfavoredOverload
	@available(*, unavailable, message: "SubscriptionUpsell.Theme was unified into KovaleeUIStyle. Rename fields: background→backgroundColor, titleColor→primaryColor, bodyColor→secondaryColor, primaryButtonBackground→ctaColor, iconSystemName→confirmationIcon, cancelPromptIconSystemName→cancelPromptIcon. iconTint, primaryButtonForeground and secondaryButtonColor no longer exist (the icon and CTA share ctaColor; the CTA label color is derived automatically; the secondary button uses secondaryColor).")
	init(
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
		self.init(
			backgroundColor: background,
			primaryColor: titleColor,
			secondaryColor: bodyColor,
			ctaColor: primaryButtonBackground,
			titleFont: titleFont,
			bodyFont: bodyFont,
			buttonFont: buttonFont,
			confirmationIcon: iconSystemName,
			cancelPromptIcon: cancelPromptIconSystemName
		)
	}
}

public extension SubscriptionUpsell.Configuration {

	@available(*, deprecated, renamed: "cancelPromptStyle")
	var cancelPromptTheme: KovaleeUIStyle? { cancelPromptStyle }

	@available(*, deprecated, renamed: "init(offeringId:trigger:triggerWithin:storageKey:condition:debugForceTrigger:showCloseButton:cancelPromptStyle:)")
	init(
		offeringId: String,
		trigger: SubscriptionUpsell.Trigger,
		triggerWithin: TimeInterval = 48 * 3600,
		storageKey: String,
		condition: SubscriptionUpsell.Condition? = nil,
		debugForceTrigger: Bool = false,
		showCloseButton: Bool = false,
		cancelPromptTheme: KovaleeUIStyle?
	) {
		self.init(
			offeringId: offeringId,
			trigger: trigger,
			triggerWithin: triggerWithin,
			storageKey: storageKey,
			condition: condition,
			debugForceTrigger: debugForceTrigger,
			showCloseButton: showCloseButton,
			cancelPromptStyle: cancelPromptTheme
		)
	}
}
#endif
