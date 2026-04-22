import Foundation
import KovaleeFramework
import KovaleeSDK

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

#if os(iOS)
@preconcurrency import TikTokBusinessSDK

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

            config.disableRetentionTracking()
            config.disablePaymentTracking()
            config.disableAutoEnhancedDataPostbackEvent()

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

        func trackRegistration(method: String?) {
            let event = TikTokBaseEvent(eventName: TTEventName.registration.rawValue)
            if let method {
                event.addProperty(withKey: "registration_method", value: method)
            }
            TikTokBusiness.trackTTEvent(event)
        }

        func trackStartTrial(productId: String, value: Double, currency: String, transactionId: String?) {
            let event = TikTokBaseEvent(
                eventName: TTEventName.startTrial.rawValue,
                eventId: transactionId ?? UUID().uuidString
            )
            event.addProperty(withKey: "content_id", value: productId)
            event.addProperty(withKey: "value", value: value)
            event.addProperty(withKey: "currency", value: currency)
            TikTokBusiness.trackTTEvent(event)
        }

        func trackSubscribe(productId: String, value: Double, currency: String, transactionId: String?) {
            let event = TikTokBaseEvent(
                eventName: TTEventName.subscribe.rawValue,
                eventId: transactionId ?? UUID().uuidString
            )
            event.addProperty(withKey: "content_id", value: productId)
            event.addProperty(withKey: "value", value: value)
            event.addProperty(withKey: "currency", value: currency)
            TikTokBusiness.trackTTEvent(event)
        }

        func trackPurchase(productId: String, value: Double, currency: String, transactionId: String?) {
            let event = TikTokPurchaseEvent(eventId: transactionId ?? UUID().uuidString)
            event.addProperty(withKey: "content_id", value: productId)
            event.addProperty(withKey: "content_type", value: "product")
            event.addProperty(withKey: "currency", value: currency)
            event.addProperty(withKey: "value", value: value)
            TikTokBusiness.trackTTEvent(event)
        }

        func trackViewContent(contentId: String?, contentType: String?) {
            let event = TikTokViewContentEvent(eventId: UUID().uuidString)
            if let contentId {
                event.addProperty(withKey: "content_id", value: contentId)
            }
            if let contentType {
                event.addProperty(withKey: "content_type", value: contentType)
            }
            TikTokBusiness.trackTTEvent(event)
        }
    }
#else
    final class TikTokWrapperImpl: Manager, TikTokManager {
        init(keys: KovaleeKeys.TikTok, debugMode: Bool) {
            TikTokWrapperRef.shared.wrapper = self
        }

        func setUserId(_ userId: String?) {
        }

        func trackEvent(_ eventName: String, properties: [String: Any]? = nil) {
        }

        func identify(
            externalId: String?,
            externalUserName: String? = nil,
            phoneNumber: String? = nil,
            email: String? = nil
        ) {
        }

        func logout() {
        }

        func setTrackingEnabled(_ enabled: Bool) {
        }

        func flush() {
        }

        func trackRegistration(method: String?) {
        }

        func trackStartTrial(productId: String, value: Double, currency: String, transactionId: String?) {
        }

        func trackSubscribe(productId: String, value: Double, currency: String, transactionId: String?) {
        }

        func trackPurchase(productId: String, value: Double, currency: String, transactionId: String?) {
        }

        func trackViewContent(contentId: String?, contentType: String?) {
        }
    }
#endif
extension TikTokWrapperImpl: @unchecked Sendable {}
