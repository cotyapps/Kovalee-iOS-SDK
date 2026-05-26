#if os(iOS)
import SwiftUI

@available(iOS 16.0, *)
struct SubscriptionUpsellDebugView: View {

	@AppStorage(SubscriptionUpsellOverride.forceTriggerKey) private var forceTrigger: Bool = false
	@State private var showResetAlert: Bool = false

	var body: some View {
		Toggle("Force Trigger on Launch", isOn: $forceTrigger)

		if forceTrigger {
			Text("Paywall will present on next foreground regardless of subscription state — only if the user hasn't seen it yet. Tap Reset Shown State to re-arm.")
				.font(.caption)
				.foregroundColor(.secondary)
		}

		Button("Reset Shown State") {
			SubscriptionUpsellOverride.clearAllShownStates()
			showResetAlert = true
		}
		.buttonStyle(.bordered)
		.alert("Subscription Upsell", isPresented: $showResetAlert) {
			Button("OK", role: .cancel) {}
		} message: {
			Text("Cleared show-once flags. The next eligible foreground will trigger the flow.")
		}

		Button("Preview Congrats Screen") {
			SubscriptionUpsell.presentCongratsScreen()
		}
		.buttonStyle(.bordered)
	}
}
#endif
