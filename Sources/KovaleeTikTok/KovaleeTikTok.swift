import Foundation
import KovaleeFramework
import KovaleeSDK

extension TikTokManagerCreator: Creator {
    public func createImplementation(
        withConfiguration configuration: Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager {
        guard let tiktokKeys = keys.tiktok else {
            fatalError("No TikTok configuration found in KovaleeKeys.json")
        }

        return TikTokWrapperImpl(
            keys: tiktokKeys,
            debugMode: configuration.environment == .development
        )
    }
}

// MARK: TikTok

public extension Kovalee {
    /// Track an event to TikTok
    ///
    /// - Parameters:
    ///   - eventName: the name of the event to track
    ///   - properties: optional dictionary of properties to attach to the event
    static func trackTikTokEvent(
        _ eventName: String,
        properties: [String: Any]? = nil
    ) {
        TikTokWrapperRef.shared.wrapper?.trackEvent(
            eventName,
            properties: properties
        )
    }

    /// Identify a user for TikTok tracking
    ///
    /// Call this method when a user logs in or registers.
    ///
    /// - Parameters:
    ///   - externalId: the external user identifier
    ///   - externalUserName: the user's display name
    ///   - phoneNumber: the user's phone number
    ///   - email: the user's email address
    static func identifyTikTokUser(
        externalId: String?,
        externalUserName: String? = nil,
        phoneNumber: String? = nil,
        email: String? = nil
    ) {
        TikTokWrapperRef.shared.wrapper?.identify(
            externalId: externalId,
            externalUserName: externalUserName,
            phoneNumber: phoneNumber,
            email: email
        )
    }

    /// Clear the current TikTok user session
    ///
    /// Call this method when a user logs out.
    static func logoutTikTok() {
        TikTokWrapperRef.shared.wrapper?.logout()
    }

    /// Enable or disable TikTok event tracking
    ///
    /// When disabled, events are still cached locally and will be sent once tracking is re-enabled.
    ///
    /// - Parameters:
    ///   - enabled: whether tracking should be enabled
    static func setTikTokTrackingEnabled(_ enabled: Bool) {
        TikTokWrapperRef.shared.wrapper?.setTrackingEnabled(enabled)
    }

    /// Explicitly flush any queued TikTok events
    static func flushTikTokEvents() {
        TikTokWrapperRef.shared.wrapper?.flush()
    }

    /// Track a TikTok standard Registration event
    ///
    /// Safe to call in apps that do not configure TikTok — the call is a no-op.
    ///
    /// - Parameters:
    ///   - method: optional registration method (e.g. "email", "apple", "google")
    static func trackTikTokRegistration(method: String? = nil) {
        TikTokWrapperRef.shared.wrapper?.trackRegistration(method: method)
    }

    /// Track a TikTok standard StartTrial event
    ///
    /// Auto-fired by the SDK from `Kovalee.purchase(package:fromSource:)` and
    /// `Kovalee.purchaseSubscription(withId:fromSource:)` when the product has a free trial.
    /// Only call manually if bypassing those APIs.
    ///
    /// Safe to call in apps that do not configure TikTok — the call is a no-op.
    ///
    /// - Parameters:
    ///   - productId: subscription product identifier
    ///   - value: trial value (usually 0 or intro price) in the given currency
    ///   - currency: ISO 4217 currency code (e.g. "USD")
    ///   - transactionId: unique transaction identifier for server-side dedup
    static func trackTikTokStartTrial(
        productId: String,
        value: Double,
        currency: String,
        transactionId: String? = nil
    ) {
        TikTokWrapperRef.shared.wrapper?.trackStartTrial(
            productId: productId,
            value: value,
            currency: currency,
            transactionId: transactionId
        )
    }

    /// Track a TikTok standard Subscribe event
    ///
    /// Auto-fired by the SDK on every successful `Kovalee.purchase(package:fromSource:)` or
    /// `Kovalee.purchaseSubscription(withId:fromSource:)`. Only call manually if bypassing
    /// those APIs.
    ///
    /// Safe to call in apps that do not configure TikTok — the call is a no-op.
    ///
    /// - Parameters:
    ///   - productId: subscription product identifier
    ///   - value: subscription price in the given currency
    ///   - currency: ISO 4217 currency code (e.g. "USD")
    ///   - transactionId: unique transaction identifier for server-side dedup
    static func trackTikTokSubscribe(
        productId: String,
        value: Double,
        currency: String,
        transactionId: String? = nil
    ) {
        TikTokWrapperRef.shared.wrapper?.trackSubscribe(
            productId: productId,
            value: value,
            currency: currency,
            transactionId: transactionId
        )
    }

    /// Track a TikTok Purchase event (renewals, one-time purchases)
    ///
    /// Pass the StoreKit/RevenueCat transaction identifier as `transactionId` so TikTok
    /// can dedupe repeated deliveries of the same transaction.
    ///
    /// Safe to call in apps that do not configure TikTok — the call is a no-op.
    ///
    /// - Parameters:
    ///   - productId: product identifier
    ///   - value: transaction price in the given currency
    ///   - currency: ISO 4217 currency code (e.g. "USD")
    ///   - transactionId: unique transaction identifier for dedup
    static func trackTikTokPurchase(
        productId: String,
        value: Double,
        currency: String,
        transactionId: String? = nil
    ) {
        TikTokWrapperRef.shared.wrapper?.trackPurchase(
            productId: productId,
            value: value,
            currency: currency,
            transactionId: transactionId
        )
    }

    /// Track a TikTok ViewContent event (e.g. paywall impression, product detail view)
    ///
    /// Safe to call in apps that do not configure TikTok — the call is a no-op.
    ///
    /// - Parameters:
    ///   - contentId: identifier for the content being viewed (e.g. paywall id, product id)
    ///   - contentType: category/type label (e.g. "paywall", "product")
    static func trackTikTokViewContent(contentId: String? = nil, contentType: String? = nil) {
        TikTokWrapperRef.shared.wrapper?.trackViewContent(contentId: contentId, contentType: contentType)
    }
}
