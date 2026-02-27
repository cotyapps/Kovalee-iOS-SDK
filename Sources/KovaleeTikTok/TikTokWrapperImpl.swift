import Foundation
import KovaleeFramework
import KovaleeSDK
@preconcurrency import TikTokBusinessSDK

/// Holds a reference to the active TikTok wrapper for use by public API methods
final class TikTokWrapperRef: @unchecked Sendable {
    static let shared = TikTokWrapperRef()

    private let lock = NSLock()
    private var _wrapper: TikTokWrapperImpl?

    var wrapper: TikTokWrapperImpl? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _wrapper
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _wrapper = newValue
        }
    }
}

final class TikTokWrapperImpl: Manager, TikTokManager {
    init(keys: KovaleeKeys.TikTok, debugMode: Bool) {
        KLogger.debug("initializing TikTok")

        guard let config = TikTokConfig(
            accessToken: keys.accessToken,
            appId: keys.appId,
            tiktokAppId: keys.tiktokAppId
        ) else {
            KLogger.error("Failed to create TikTok configuration")
            return
        }

        if debugMode {
            config.enableDebugMode()
        }

        TikTokBusiness.initializeSdk(config)
        TikTokWrapperRef.shared.wrapper = self
    }

    func setUserId(_ userId: String?) {
        TikTokBusiness.identify(
            withExternalID: userId,
            externalUserName: nil,
            phoneNumber: nil,
            email: nil
        )
    }

    func trackEvent(_ eventName: String, properties: [String: Any]? = nil) {
        let event = TikTokBaseEvent(eventName: eventName)
        if let properties {
            for (key, value) in properties {
                event.addProperty(withKey: key, value: value)
            }
        }
        TikTokBusiness.trackTTEvent(event)
    }

    func identify(
        externalId: String?,
        externalUserName: String? = nil,
        phoneNumber: String? = nil,
        email: String? = nil
    ) {
        TikTokBusiness.identify(
            withExternalID: externalId,
            externalUserName: externalUserName,
            phoneNumber: phoneNumber,
            email: email
        )
    }

    func logout() {
        TikTokBusiness.logout()
    }

    func setTrackingEnabled(_ enabled: Bool) {
        TikTokBusiness.setTrackingEnabled(enabled)
    }

    func flush() {
        TikTokBusiness.explicitlyFlush()
    }
}

extension TikTokWrapperImpl: @unchecked Sendable {}
