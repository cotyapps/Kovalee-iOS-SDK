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
}
