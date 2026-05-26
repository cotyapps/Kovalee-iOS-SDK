#if os(iOS)
import Foundation
import KovaleeSDK

enum SubscriptionUpsellAnalytics {

	enum Source: String {
		case auto      // regular foreground / trial-detection path
		case forced    // deep-link / presentNow path
	}

	/// Correlation context attached to every event in a single upsell flow so
	/// the post-purchase funnel (confirmation → manage subs → dismiss) can be
	/// joined back to the originating paywall in analytics.
	struct Context {
		let source: Source
		let offeringId: String
	}

	static func paywallShown(in context: Context) {
		Kovalee.sendEvent(withName: "subscription_upsell_paywall_shown", andProperties: [
			"source": context.source.rawValue,
			"offering_id": context.offeringId,
		])
	}

	static func paywallClosed(in context: Context, purchased: Bool) {
		Kovalee.sendEvent(withName: "subscription_upsell_paywall_closed", andProperties: [
			"source": context.source.rawValue,
			"offering_id": context.offeringId,
			"purchased": purchased,
		])
	}

	static func purchased(in context: Context) {
		Kovalee.sendEvent(withName: "subscription_upsell_purchased", andProperties: [
			"source": context.source.rawValue,
			"offering_id": context.offeringId,
		])
	}

	static func confirmationOkTapped(in context: Context) {
		Kovalee.sendEvent(withName: "subscription_upsell_confirmation_ok_tapped", andProperties: [
			"source": context.source.rawValue,
			"offering_id": context.offeringId,
		])
	}

	static func manageSubscriptionsOpened(in context: Context) {
		Kovalee.sendEvent(withName: "subscription_upsell_manage_subs_opened", andProperties: [
			"source": context.source.rawValue,
			"offering_id": context.offeringId,
		])
	}

	static func renewalCancellationDetected(in context: Context) {
		Kovalee.sendEvent(withName: "subscription_upsell_renewal_cancelled_detected", andProperties: [
			"source": context.source.rawValue,
			"offering_id": context.offeringId,
		])
	}

	static func dismissedLater(in context: Context, renewalCancelled: Bool) {
		Kovalee.sendEvent(withName: "subscription_upsell_dismissed_later", andProperties: [
			"source": context.source.rawValue,
			"offering_id": context.offeringId,
			"renewal_cancelled": renewalCancelled,
		])
	}
}
#endif
