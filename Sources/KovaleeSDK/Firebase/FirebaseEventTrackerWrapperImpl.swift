import Foundation
import KovaleeFramework

#if canImport(FirebaseAnalytics)
    import FirebaseAnalytics

    struct FirebaseEventTrackerWrapperImpl: EventTrackerManager, Manager {
        init() {
            KLogger.debug("initializing Firebase Analytics event tracker")
        }

        func sendEvent(_ event: Event) {
            guard let name = Self.sanitizeEventName(event.name) else {
                KLogger.warn("Firebase: dropping event with unsanitizable name '\(event.name)'")
                return
            }
            let parameters = Self.sanitizeParameters(event.properties ?? [:])
            Analytics.logEvent(name, parameters: parameters)
            KLogger.debug("Firebase: logged event \(name) with \(parameters.count) params")
        }

        func setUserId(_ userId: String) {
            Analytics.setUserID(userId)
        }

        func setDeviceId(_ deviceId: String) {
            // Firebase Analytics uses its own app-instance ID; no public setter.
        }

        func setUserProperty(key: String, value: String) {
            guard let sanitizedKey = Self.sanitizeUserPropertyName(key) else {
                KLogger.warn("Firebase: dropping user property with invalid name '\(key)'")
                return
            }
            // Firebase caps user property values at 36 characters.
            Analytics.setUserProperty(Self.truncate(value, to: 36), forName: sanitizedKey)
        }

        func setUserProperty(property: UserProperty) {
            setUserProperty(key: property.key, value: property.value)
        }

        func setUserProperties(_ properties: [String: String]) {
            for (k, v) in properties { setUserProperty(key: k, value: v) }
        }

        func setDataCollectionEnabled(_ enabled: Bool) {
            // Already handled by KovaleeRemoteConfig/FirebaseWrapperImpl.setDataCollectionEnabled,
            // which routes to Analytics.setAnalyticsCollectionEnabled. No-op here to avoid double-calls.
        }

        func flush() {
            // Firebase Analytics has no public flush API; events are dispatched on its own schedule.
        }

        func getUserId() -> String? { nil }
        func getDeviceId() -> String? { nil }
    }

    // MARK: - GA4 sanitization

    extension FirebaseEventTrackerWrapperImpl {
        // GA4 reserved event names cannot be used for custom events.
        // https://firebase.google.com/docs/reference/cpp/group/event-names
        private static let reservedEventNames: Set<String> = [
            "ad_activeview", "ad_click", "ad_exposure", "ad_impression", "ad_query",
            "ad_reward", "adunit_exposure", "app_clear_data", "app_exception",
            "app_remove", "app_store_refund", "app_store_subscription_cancel",
            "app_store_subscription_convert", "app_store_subscription_renew",
            "app_update", "app_upgrade", "dynamic_link_app_open",
            "dynamic_link_app_update", "dynamic_link_first_open", "error",
            "first_open", "first_visit", "in_app_purchase", "notification_dismiss",
            "notification_foreground", "notification_open", "notification_receive",
            "notification_send", "os_update", "screen_view", "session_start",
            "user_engagement"
        ]

        private static let eventNameAllowedPattern = try? NSRegularExpression(
            pattern: "[^A-Za-z0-9_]"
        )

        static func sanitizeEventName(_ raw: String) -> String? {
            guard let truncated = sanitizeName(raw, maxLength: 40) else { return nil }
            guard !reservedEventNames.contains(truncated.lowercased()) else {
                return nil
            }
            return truncated
        }

        static func sanitizeUserPropertyName(_ raw: String) -> String? {
            sanitizeName(raw, maxLength: 24)
        }

        static func sanitizeParameterName(_ raw: String) -> String? {
            sanitizeName(raw, maxLength: 40)
        }

        private static func sanitizeName(_ raw: String, maxLength: Int) -> String? {
            let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return nil }

            let range = NSRange(trimmed.startIndex..., in: trimmed)
            let replaced = eventNameAllowedPattern?.stringByReplacingMatches(
                in: trimmed, range: range, withTemplate: "_"
            ) ?? trimmed

            // Must start with a letter or underscore.
            let leadingFixed = replaced.first?.isLetter == true || replaced.first == "_"
                ? replaced
                : "_" + replaced

            return truncate(leadingFixed, to: maxLength)
        }

        static func sanitizeParameters(_ raw: [String: any Sendable]) -> [String: Any] {
            var out: [String: Any] = [:]
            for (key, value) in raw {
                guard out.count < 25 else { break }
                guard let cleanKey = sanitizeParameterName(key) else { continue }
                if let s = value as? String {
                    out[cleanKey] = truncate(s, to: 100)
                } else if let b = value as? Bool {
                    out[cleanKey] = b ? 1 : 0
                } else if let i = value as? Int {
                    out[cleanKey] = i
                } else if let d = value as? Double {
                    out[cleanKey] = d
                } else if let n = value as? NSNumber {
                    out[cleanKey] = n
                } else {
                    out[cleanKey] = truncate(String(describing: value), to: 100)
                }
            }
            return out
        }

        static func truncate(_ s: String, to max: Int) -> String {
            s.count <= max ? s : String(s.prefix(max))
        }
    }
#else
    struct FirebaseEventTrackerWrapperImpl: EventTrackerManager, Manager {
        init() {}
        func sendEvent(_ event: Event) {}
        func setUserId(_ userId: String) {}
        func setDeviceId(_ deviceId: String) {}
        func setUserProperty(key: String, value: String) {}
        func setUserProperty(property: UserProperty) {}
        func setUserProperties(_ properties: [String: String]) {}
        func setDataCollectionEnabled(_ enabled: Bool) {}
        func flush() {}
        func getUserId() -> String? { nil }
        func getDeviceId() -> String? { nil }
    }
#endif
