#if os(iOS)
import SwiftUI

@available(iOS 16.0, *)
struct SubscriptionUpsellDebugView: View {

	@AppStorage(SubscriptionUpsellOverride.forceTriggerKey) private var forceTrigger: Bool = false
	@State private var showResetAlert: Bool = false

	var body: some View {
		Toggle("Force Trigger on Launch", isOn: $forceTrigger)

		VStack(spacing: 10) {
			if forceTrigger {
				Text("Paywall will present on next foreground regardless of subscription state — only if the user hasn't seen it yet. Tap Reset Shown State to re-arm.")
					.font(.caption)
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
			}

			Button {
				SubscriptionUpsell.presentCongratsScreen()
			} label: {
				Label("Preview Congrats Screen", systemImage: "eye")
			}
			.buttonStyle(.debugPrimary)

			Button {
				SubscriptionUpsellOverride.clearAllShownStates()
				showResetAlert = true
			} label: {
				Label("Reset Shown State", systemImage: "arrow.clockwise")
			}
			.buttonStyle(.debugSecondary)
		}
		.alert("Subscription Upsell", isPresented: $showResetAlert) {
			Button("OK", role: .cancel) {}
		} message: {
			Text("Cleared show-once flags. The next eligible foreground will trigger the flow.")
		}
	}
}
#endif
