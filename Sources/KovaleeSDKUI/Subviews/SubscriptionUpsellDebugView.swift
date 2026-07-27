#if os(iOS)
import SwiftUI
import RevenueCat

@available(iOS 16.0, *)
struct SubscriptionUpsellDebugView: View {

	@AppStorage(SubscriptionUpsellOverride.forceTriggerKey) private var forceTrigger: Bool = false
	@State private var showResetAlert: Bool = false

	@State private var offeringIds: [String] = []
	@State private var currentOfferingId: String?
	@State private var offeringsState: OfferingsState = .idle

	private enum OfferingsState: Equatable {
		case idle
		case loading
		case loaded
		case failed(String)
	}

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

		presentPaywallSection
			.task { await loadOfferings() }
	}


	/// Presents the real upsell paywall on demand, bypassing eligibility and the
	/// show-once gate. Lists every RevenueCat offering so QA can test any paywall
	/// without knowing the host app's configured offering id.
	@ViewBuilder
	private var presentPaywallSection: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("Present Paywall")
				.font(.footnote.weight(.semibold))
				.foregroundStyle(.secondary)
				.frame(maxWidth: .infinity, alignment: .leading)

			switch offeringsState {
			case .idle, .loading:
				HStack(spacing: 8) {
					ProgressView()
					Text("Loading offerings…")
						.font(.caption)
						.foregroundStyle(.secondary)
				}
				.frame(maxWidth: .infinity, alignment: .leading)

			case .failed(let message):
				VStack(alignment: .leading, spacing: 8) {
					Text("Couldn't load offerings: \(message)")
						.font(.caption)
						.foregroundStyle(.red)
						.frame(maxWidth: .infinity, alignment: .leading)

					Button {
						Task { await reloadOfferings() }
					} label: {
						Label("Retry", systemImage: "arrow.clockwise")
					}
					.buttonStyle(.debugSecondary)
				}

			case .loaded where offeringIds.isEmpty:
				Text("No offerings found in RevenueCat.")
					.font(.caption)
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)

			case .loaded:
				ForEach(offeringIds, id: \.self) { id in
					Button {
						SubscriptionUpsellDebug.presentPaywall(offeringId: id)
					} label: {
						Label(label(for: id), systemImage: "creditcard")
					}
					.buttonStyle(.debugSecondary)
				}
			}
		}
	}


	private func label(for id: String) -> String {
		id == currentOfferingId ? "\(id) (current)" : id
	}


	@MainActor
	private func reloadOfferings() async {
		offeringsState = .idle
		await loadOfferings()
	}


	@MainActor
	private func loadOfferings() async {
		guard offeringsState == .idle else { return }
		guard Purchases.isConfigured else {
			offeringsState = .failed("Purchases not configured")
			return
		}
		offeringsState = .loading
		do {
			let offerings = try await Purchases.shared.offerings()
			currentOfferingId = offerings.current?.identifier
			offeringIds = offerings.all.keys.sorted()
			offeringsState = .loaded
		}
		catch {
			offeringsState = .failed(error.localizedDescription)
		}
	}
}


/// Debug-only bridge that force-presents the upsell paywall from the top-most
/// view controller, so the debug menu doesn't need a `UIViewController` handle.
private enum SubscriptionUpsellDebug {

	@MainActor
	static func presentPaywall(offeringId: String) {
		guard let presenter = TopPresenter.current else { return }
		SubscriptionUpsell.presentNow(
			configuration: SubscriptionUpsell.Configuration(
				offeringId: offeringId,
				trigger: .anySubscription,
				storageKey: "debug.\(offeringId)",
				showCloseButton: true
			),
			from: presenter
		)
	}
}
#endif
