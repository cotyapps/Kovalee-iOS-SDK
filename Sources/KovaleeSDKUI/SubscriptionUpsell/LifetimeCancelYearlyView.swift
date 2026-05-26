import Foundation
#if os(iOS)
import SwiftUI
import StoreKit
import UIKit

struct LifetimeCancelYearlyView: View {
	@Environment(\.dismiss) private var dismiss
	let theme: SubscriptionUpsell.Theme
	let sourceProduct: Product?
	/// Correlation for funnel analytics. `nil` when the screen is shown as a
	/// standalone preview (debug menu) — no events are fired in that case.
	let analyticsContext: SubscriptionUpsellAnalytics.Context?
	let onDismiss: @MainActor () -> Void

	@State private var step: Step = .confirmation
	@State private var didCancelTrialRenewal: Bool = false
	@State private var isLoading: Bool = false
	@State private var errorMessage: String? = nil
	@State private var initialWillAutoRenew: Bool? = nil
	@State private var didFireDismiss: Bool = false

	private enum Step {
		case confirmation
		case cancelPrompt
	}

	var body: some View {
		ZStack {
			theme.background.ignoresSafeArea()

			switch step {
			case .confirmation: confirmationStep
			case .cancelPrompt: cancelPromptStep
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.animation(.easeInOut(duration: 0.25), value: step)
		.task {
			initialWillAutoRenew = await fetchWillAutoRenew()
		}
		.task(id: didCancelTrialRenewal) {
			guard didCancelTrialRenewal else { return }
			try? await Task.sleep(nanoseconds: 450_000_000)
			fireDismissOnce()
		}
	}


	private var confirmationStep: some View {
		VStack(spacing: 24) {
			Spacer()

			Image(systemName: theme.iconSystemName)
				.font(.system(size: 56))
				.foregroundStyle(theme.iconTint)

			Text("Lifetime unlocked", bundle: .module)
				.font(theme.titleFont)
				.foregroundStyle(theme.titleColor)
				.multilineTextAlignment(.center)

			Text("Your lifetime access is now active.", bundle: .module)
				.font(theme.bodyFont)
				.multilineTextAlignment(.center)
				.foregroundStyle(theme.bodyColor)
				.padding(.horizontal, 24)

			Spacer()

			Button {
				analyticsContext.map(SubscriptionUpsellAnalytics.confirmationOkTapped(in:))
				step = .cancelPrompt
			} label: {
				Text("OK", bundle: .module)
					.font(theme.buttonFont)
					.foregroundStyle(theme.primaryButtonForeground)
					.frame(maxWidth: .infinity)
					.frame(height: 56)
					.background(Capsule().fill(theme.primaryButtonBackground))
			}
			.padding(.horizontal, 24)
			.padding(.bottom, 24)
		}
	}


	private var cancelPromptStep: some View {
		VStack(spacing: 24) {
			Spacer()

			Image(systemName: theme.cancelPromptIconSystemName)
				.font(.system(size: 56))
				.foregroundStyle(theme.iconTint)

			Text("One last step", bundle: .module)
				.font(theme.titleFont)
				.foregroundStyle(theme.titleColor)
				.multilineTextAlignment(.center)

			Text("Turn off auto-renewal on your existing subscription so the App Store doesn't charge you again.", bundle: .module)
				.font(theme.bodyFont)
				.multilineTextAlignment(.center)
				.foregroundStyle(theme.bodyColor)
				.padding(.horizontal, 24)

			if let errorMessage {
				Text(errorMessage)
					.font(.caption)
					.foregroundStyle(.red)
					.padding(.horizontal, 24)
			}

			Spacer()

			Button {
				analyticsContext.map(SubscriptionUpsellAnalytics.manageSubscriptionsOpened(in:))
				Task { await openManageSubscriptions() }
			} label: {
				ZStack {
					if isLoading {
						ProgressView().tint(theme.primaryButtonForeground)
					}
					else {
						Text("Open subscription settings", bundle: .module)
					}
				}
				.font(theme.buttonFont)
				.foregroundStyle(theme.primaryButtonForeground)
				.frame(maxWidth: .infinity)
				.frame(height: 56)
				.background(Capsule().fill(theme.primaryButtonBackground))
			}
			.disabled(isLoading)
			.padding(.horizontal, 24)

			Button {
				if let analyticsContext {
					SubscriptionUpsellAnalytics.dismissedLater(in: analyticsContext, renewalCancelled: didCancelTrialRenewal)
				}
				fireDismissOnce()
			} label: {
				Text("I'll do it later", bundle: .module)
					.font(.subheadline)
					.foregroundStyle(theme.secondaryButtonColor)
			}
			.padding(.bottom, 24)
		}
	}


	/// Dismisses the view and fires `onDismiss` exactly once. Multiple callers
	/// (the "I'll do it later" button, the auto-dismiss after cancellation, the
	/// no-source-product fallback) can race; this guard ensures the host's
	/// completion callback isn't invoked twice.
	@MainActor
	private func fireDismissOnce() {
		guard !didFireDismiss else { return }
		didFireDismiss = true
		dismiss()
		onDismiss()
	}


	@MainActor
	private func openManageSubscriptions() async {
		errorMessage = nil
		isLoading = true
		// `defer` bodies are synchronous, so we kick off a Task to do the
		// post-sheet renewal check on every exit path (success, no-scene,
		// sheet error). The `.task(id: didCancelTrialRenewal)` handler
		// then drives the auto-dismiss through `fireDismissOnce()`.
		defer {
			Task { @MainActor in
				guard let current = await fetchWillAutoRenew() else {
					didCancelTrialRenewal = true
					isLoading = false
					return
				}
				if initialWillAutoRenew == true, current == false {
					if !didCancelTrialRenewal {
						analyticsContext.map(SubscriptionUpsellAnalytics.renewalCancellationDetected(in:))
					}
					didCancelTrialRenewal = true
				}
				isLoading = false
			}
		}

		// Hydrate the baseline before opening the sheet — the `.task`-driven
		// fetch may not have completed yet if the user taps quickly. Without
		// this, the post-sheet check sees a nil baseline and can't tell whether
		// auto-renew was toggled off.
		if initialWillAutoRenew == nil, sourceProduct != nil {
			initialWillAutoRenew = await fetchWillAutoRenew()
		}

		guard let scene = Self.currentForegroundScene() else {
			errorMessage = String(localized: "No active window scene.", bundle: .module)
			return
		}
		do {
			try await AppStore.showManageSubscriptions(in: scene)
		}
		catch {
			errorMessage = error.localizedDescription
			return
		}
	}

	private func fetchWillAutoRenew() async -> Bool? {
		guard let product = sourceProduct, let subscription = product.subscription else { return nil }
		do {
			let statuses = try await subscription.status
			for status in statuses {
				guard case .verified(let renewalInfo) = status.renewalInfo,
				      case .verified(let transaction) = status.transaction,
				      transaction.productID == product.id
				else { continue }
				return renewalInfo.willAutoRenew
			}
			return nil
		}
		catch {
			return nil
		}
	}


	@MainActor
	private static func currentForegroundScene() -> UIWindowScene? {
		UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first { $0.activationState == .foregroundActive }
			?? UIApplication.shared.connectedScenes
				.compactMap { $0 as? UIWindowScene }
				.first
	}
}


extension LifetimeCancelYearlyView {

	@MainActor
	static func launchAtTop(
		theme: SubscriptionUpsell.Theme,
		sourceProduct: Product? = nil,
		analyticsContext: SubscriptionUpsellAnalytics.Context? = nil,
		onDismiss: @escaping @MainActor () -> Void
	) {
		guard let topPresenter = Self.topPresenter else {
			onDismiss()
			return
		}
		let host = UIHostingController(
			rootView: LifetimeCancelYearlyView(
				theme: theme,
				sourceProduct: sourceProduct,
				analyticsContext: analyticsContext,
				onDismiss: onDismiss
			)
		)
		host.modalPresentationStyle = .fullScreen
		topPresenter.present(host, animated: true)
	}


	@MainActor
	private static var topPresenter: UIViewController? {
		let scene = UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first { $0.activationState == .foregroundActive }
			?? UIApplication.shared.connectedScenes
				.compactMap { $0 as? UIWindowScene }
				.first
		guard let root = scene?.keyWindow?.rootViewController else { return nil }
		var top = root
		while let presented = top.presentedViewController {
			top = presented
		}
		return top
	}
}
#endif
