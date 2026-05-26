import Foundation
#if os(iOS)
import UIKit
import SwiftUI
import StoreKit
import KovaleeFramework
import RevenueCat
import RevenueCatUI

enum SubscriptionUpsellPresenter {

	/// Keys for which a `run` Task is currently executing. Used to suppress
	/// duplicate invocations triggered close together (e.g. the SwiftUI
	/// modifier's `task(id: scenePhase)` re-firing on rapid scene-phase
	/// oscillation). Tracked separately from `inFlightForced` so a deep-link
	/// `runForced` isn't blocked by an in-progress trial-detection `run`.
	@MainActor
	private static var inFlight: Set<String> = []

	/// Keys for which a `runForced` Task is currently executing. Independent of
	/// `inFlight` so the deliberate deep-link / `presentNow` path is never
	/// suppressed by a concurrent `run`.
	@MainActor
	private static var inFlightForced: Set<String> = []


	/// Generic entry that accepts a presentation closure so both UIKit and
	/// SwiftUI hosts can drive the flow.
	///
	/// If another `run` / `runForced` is already in flight for the same
	/// `storageKey`, this call is a no-op and `onCompletion` is not invoked
	/// (the in-flight call owns the completion contract).
	@MainActor
	static func run(
		configuration: SubscriptionUpsell.Configuration,
		present: @escaping @MainActor (UIViewController) -> Bool,
		onCompletion: (@MainActor @Sendable (SubscriptionUpsell.Outcome) -> Void)?
	) {
		let storage = UpsellStorage(key: configuration.storageKey)
		if storage.hasShown {
			onCompletion?(.notTriggered)
			return
		}
		guard !inFlight.contains(configuration.storageKey) else { return }
		inFlight.insert(configuration.storageKey)

		let forceTrigger = configuration.debugForceTrigger || SubscriptionUpsellOverride.forceTrigger
		let storageKey = configuration.storageKey

		Task { @MainActor in
			defer { inFlight.remove(storageKey) }
			do {
				let offerings = try await Purchases.shared.offerings()
				let productIds = resolveProductIdentifiers(for: configuration.trigger, in: offerings)

				let matchedProductId: String?
				if forceTrigger {
					matchedProductId = productIds.first
				}
				else {
					guard let entitlement = try await findExpiringTrialEntitlement(
						productIdentifiers: productIds,
						within: configuration.triggerWithin
					) else {
						onCompletion?(.notTriggered)
						return
					}
					matchedProductId = entitlement.productIdentifier
				}

				guard let offering = offerings.offering(identifier: configuration.offeringId) else {
					KLogger.error("[SubscriptionUpsell] offering not found: \(configuration.offeringId)")
					onCompletion?(.notTriggered)
					return
				}

				let sourceProduct = await fetchSourceProduct(id: matchedProductId)

				let context = SubscriptionUpsellAnalytics.Context(source: .auto, offeringId: configuration.offeringId)
				let paywall = makePaywallController(
					offering: offering,
					sourceProduct: sourceProduct,
					showCloseButton: configuration.showCloseButton,
					cancelPromptTheme: configuration.cancelPromptTheme ?? SubscriptionUpsell.defaultCancelPromptTheme,
					analyticsContext: context,
					onCompletion: onCompletion
				)
				// Only consume the show-once budget if the host can actually
				// present. If `present` returns false the paywall never
				// reaches the screen and the host's completion would be
				// orphaned (paywall callbacks never fire), so we synthesize
				// `.notTriggered` here.
				guard present(paywall) else {
					onCompletion?(.notTriggered)
					return
				}
				storage.markShown()
				SubscriptionUpsellAnalytics.paywallShown(in: context)
			}
			catch {
				KLogger.error("[SubscriptionUpsell] failed to evaluate trigger: \(error)")
				onCompletion?(.notTriggered)
			}
		}
	}


	private static func fetchSourceProduct(id: String?) async -> Product? {
		guard let id else { return nil }
		do {
			return try await Product.products(for: [id]).first
		}
		catch {
			KLogger.error("[SubscriptionUpsell] failed to fetch StoreKit product \(id): \(error)")
			return nil
		}
	}


	/// Bypasses every gate (show-once, trial detection) and just presents the
	/// paywall. Backing implementation for `SubscriptionUpsell.presentNow(...)`
	/// and the deep-link entry point.
	///
	/// Independent of `run`'s in-flight tracking — a deep link arriving while
	/// `run` is still doing its async trial check is never silently dropped.
	/// Only dedupes back-to-back `runForced` calls for the same `storageKey`.
	@MainActor
	static func runForced(
		configuration: SubscriptionUpsell.Configuration,
		present: @escaping @MainActor (UIViewController) -> Bool,
		onCompletion: (@MainActor @Sendable (SubscriptionUpsell.Outcome) -> Void)?
	) {
		guard !inFlightForced.contains(configuration.storageKey) else { return }
		inFlightForced.insert(configuration.storageKey)
		let storageKey = configuration.storageKey

		Task { @MainActor in
			defer { inFlightForced.remove(storageKey) }
			do {
				let offerings = try await Purchases.shared.offerings()
				guard let offering = offerings.offering(identifier: configuration.offeringId) else {
					KLogger.error("[SubscriptionUpsell] offering not found: \(configuration.offeringId)")
					onCompletion?(.notTriggered)
					return
				}
				let context = SubscriptionUpsellAnalytics.Context(source: .forced, offeringId: configuration.offeringId)
				let paywall = makePaywallController(
					offering: offering,
					sourceProduct: nil,
					showCloseButton: configuration.showCloseButton,
					cancelPromptTheme: configuration.cancelPromptTheme ?? SubscriptionUpsell.defaultCancelPromptTheme,
					analyticsContext: context,
					onCompletion: onCompletion
				)
				guard present(paywall) else {
					onCompletion?(.notTriggered)
					return
				}
				SubscriptionUpsellAnalytics.paywallShown(in: context)
			}
			catch {
				KLogger.error("[SubscriptionUpsell] presentNow failed: \(error)")
				onCompletion?(.notTriggered)
			}
		}
	}


	private static func resolveProductIdentifiers(
		for trigger: SubscriptionUpsell.Trigger,
		in offerings: Offerings
	) -> Set<String> {
		if case .productIdentifiers(let ids) = trigger {
			return ids
		}
		var ids = Set<String>()
		for offering in offerings.all.values {
			for package in offering.availablePackages {
				let unit = package.storeProduct.subscriptionPeriod?.unit
				if matches(trigger: trigger, unit: unit) {
					ids.insert(package.storeProduct.productIdentifier)
				}
			}
		}
		return ids
	}


	private static func matches(trigger: SubscriptionUpsell.Trigger, unit: RevenueCat.SubscriptionPeriod.Unit?) -> Bool {
		guard let unit else { return false }
		switch trigger {
			case .yearly: return unit == .year
			case .monthly: return unit == .month
			case .weekly: return unit == .week
			case .anySubscription: return true
			case .productIdentifiers: return false  // handled above
		}
	}


	@MainActor
	private static func makePaywallController(
		offering: Offering,
		sourceProduct: Product?,
		showCloseButton: Bool,
		cancelPromptTheme: SubscriptionUpsell.Theme,
		analyticsContext: SubscriptionUpsellAnalytics.Context,
		onCompletion: (@MainActor @Sendable (SubscriptionUpsell.Outcome) -> Void)?
	) -> UIViewController {

		let purchaseSignal = PurchaseSignal()
		let view = PaywallView(offering: offering)
			.onPurchaseCompleted { _ in
				purchaseSignal.didPurchase = true
				SubscriptionUpsellAnalytics.purchased(in: analyticsContext)
			}
			.onRequestedDismissal {
				purchaseSignal.requestDismiss?()
			}
			.overlay(alignment: .topLeading) {
				if showCloseButton {
					Button {
						purchaseSignal.requestDismiss?()
					} label: {
						Image(systemName: "xmark.circle.fill")
							.font(.system(size: 28))
							.symbolRenderingMode(.palette)
							.foregroundStyle(Color.white.opacity(0.9), Color.black.opacity(0.5))
					}
					.accessibilityLabel(Text("Close", bundle: .module))
					.padding(.leading, 16)
					.padding(.top, 8)
				}
			}

		let host = UIHostingController(rootView: view)
		host.modalPresentationStyle = .fullScreen

		// `[weak purchaseSignal]` breaks the self-retain cycle that would
		// otherwise occur because the closure is stored on `purchaseSignal`
		// itself (`purchaseSignal.requestDismiss = …`).
		purchaseSignal.requestDismiss = { [weak host, weak purchaseSignal] in
			guard let host, let purchaseSignal else { return }
			let purchased = purchaseSignal.didPurchase
			SubscriptionUpsellAnalytics.paywallClosed(in: analyticsContext, purchased: purchased)
			host.dismiss(animated: true) {
				if purchased {
					LifetimeCancelYearlyView.launchAtTop(
						theme: cancelPromptTheme,
						sourceProduct: sourceProduct,
						analyticsContext: analyticsContext
					) {
						onCompletion?(.purchased)
					}
				}
				else {
					onCompletion?(.dismissed)
				}
			}
		}

		return host
	}


	private static func findExpiringTrialEntitlement(
		productIdentifiers: Set<String>,
		within: TimeInterval
	) async throws -> EntitlementInfo? {
		let info = try await Purchases.shared.customerInfo()
		return info.entitlements.active.values.first { entitlement in
			guard entitlement.periodType == .trial else { return false }
			guard productIdentifiers.contains(entitlement.productIdentifier) else { return false }
			guard let expiration = entitlement.expirationDate else { return false }
			let remaining = expiration.timeIntervalSinceNow
			return remaining > 0 && remaining <= within
		}
	}
}


@MainActor
private final class PurchaseSignal {
	var didPurchase: Bool = false
	var requestDismiss: (() -> Void)?
}


struct UpsellStorage {
	let key: String

	private var namespacedKey: String { "kovalee.subscriptionUpsell.\(key).shownAt" }

	var hasShown: Bool {
		UserDefaults.standard.object(forKey: namespacedKey) != nil
	}

	func markShown() {
		UserDefaults.standard.set(Date(), forKey: namespacedKey)
	}
}
#endif
