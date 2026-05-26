#if os(iOS)
import Foundation

/// Persistent overrides used by the SDK debug panel to drive the upsell flow
/// for QA without code changes. Apply on every launch / foreground until
/// toggled off in the debug menu.
public enum SubscriptionUpsellOverride {

	/// When `true`, the orchestrator behaves as if a matching trial entitlement
	/// existed and presents the paywall regardless of subscription state or the
	/// show-once flag. Equivalent to `Configuration(debugForceTrigger: true)`
	/// without rebuilding the host app.
	public static let forceTriggerKey = "kovalee.subscriptionUpsell.debugForceTrigger"

	static var forceTrigger: Bool {
		guard Config.isDebugOrTestflight else { return false }
		return UserDefaults.standard.bool(forKey: forceTriggerKey)
	}

	/// Removes every show-once flag under the `kovalee.subscriptionUpsell.*`
	/// namespace so the flow can fire again.
	public static func clearAllShownStates() {
		let defaults = UserDefaults.standard
		for key in defaults.dictionaryRepresentation().keys where
			key.hasPrefix("kovalee.subscriptionUpsell.") && key.hasSuffix(".shownAt")
		{
			defaults.removeObject(forKey: key)
		}
	}
}
#endif
