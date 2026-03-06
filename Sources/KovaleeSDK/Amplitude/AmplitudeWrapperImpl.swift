import Foundation
import KovaleeFramework

#if canImport(AmplitudeSwiftSessionReplayPlugin)
    import AmplitudeSwiftSessionReplayPlugin
#endif

#if canImport(AmplitudeSwift)
    import AmplitudeSwift

    struct AmplitudeWrapperImpl: EventTrackerManager, Manager {

        init(withKey key: String, amplitudeTrackingEnable: Bool = true, sessionReplayPluginEnabled: Bool = false) {
            KLogger.debug("initializing Amplitude")
            self.amplitudeTrackingEnable = amplitudeTrackingEnable
            let trackingOptions = TrackingOptions()
                .disableTrackCarrier()
                .disableTrackCity()
                .disableTrackIDFV()

            let amplitude = Amplitude(
                configuration: AmplitudeSwift.Configuration(
                    apiKey: key,
                    logLevel: KovaleeFramework.LogLevel.amplitudeLogLevel(KLogger.logLevel),
                    callback: { event, code, message in
                        KLogger.debug("\(code): \(message) → \(event.description)")
                    },
                    trackingOptions: trackingOptions,
                    flushEventsOnClose: true
                )
            )
            amplitudeStore = .init(amplitude)

            #if canImport(AmplitudeSwiftSessionReplayPlugin)
                if sessionReplayPluginEnabled {
                    amplitudeStore.withAmplitude { $0?.add(plugin: AmplitudeSwiftSessionReplayPlugin()) }
                }
            #endif

        }

        func setDataCollectionEnabled(_ enabled: Bool) {
            amplitudeStore.withAmplitude { $0?.configuration.optOut = !enabled }
        }

        func sendEvent(_ event: Event) {
            guard amplitudeTrackingEnable else {
                KLogger.warn("Amplitude tracking disabled - not sending Event: \(event.name) \(event.properties?.serialization ?? "")")
                return
            }

            let didTrack = amplitudeStore.withAmplitude { amplitude in
                guard let amplitude else { return false }
                amplitude.track(
                    eventType: event.name,
                    eventProperties: event.properties ?? [:]
                )
                return true
            }

            guard didTrack else {
                KLogger.error("Failed sending Event: \(event.name) \(event.properties?.serialization ?? "")")
                return
            }

            KLogger.debug("Sending Event: \(event.name) \(event.properties?.serialization ?? "")")
        }

        func setUserId(_ userId: String) {
            amplitudeStore.withAmplitude { $0?.setUserId(userId: userId) }
            KLogger.debug("Setting userId: \(userId)")
        }

        func setDeviceId(_ deviceId: String) {
            amplitudeStore.withAmplitude { $0?.setDeviceId(deviceId: deviceId) }
            KLogger.debug("Setting deviceId: \(deviceId)")
        }

        func setUserProperty(key: String, value: String) {
            amplitudeStore.withAmplitude {
                $0?.identify(
                    identify: Identify().set(property: key, value: value)
                )
            }

            KLogger.debug("Setting user property: \(key) → \(value)")
        }

        func setUserProperties(_ properties: [String: String]) {
            amplitudeStore.withAmplitude { $0?.identify(userProperties: properties) }
        }

        func flush() {
            amplitudeStore.withAmplitude { $0?.flush() }
            KLogger.debug("Flushing Amplitude events")
        }

        func setUserProperty(property: UserProperty) {
            setUserProperty(key: property.key, value: property.value)
        }

        func getUserId() -> String? {
            amplitudeStore.withAmplitude { $0?.getUserId() }
        }

        func getDeviceId() -> String? {
            amplitudeStore.withAmplitude { $0?.getDeviceId() }
        }

        private let amplitudeStore: LockedAmplitudeStore

        let amplitudeTrackingEnable: Bool

    }

    private final class LockedAmplitudeStore: @unchecked Sendable {
        private var amplitude: Amplitude?
        private let lock = NSLock()

        init(_ amplitude: Amplitude?) {
            self.amplitude = amplitude
        }

        @discardableResult
        func withAmplitude<T>(_ action: (Amplitude?) -> T) -> T {
            lock.lock()
            defer { lock.unlock() }
            return action(amplitude)
        }
    }

    extension BaseEvent {
        var description: String {
            guard let properties = eventProperties else {
                return eventType
            }

            return eventType + " " + properties.description
        }
    }

    extension KovaleeFramework.LogLevel {
        static func amplitudeLogLevel(_ level: KovaleeFramework.LogLevel) -> AmplitudeSwift.LogLevelEnum {
            switch level {
            case .verbose:
                return .LOG
            case .debug:
                return .DEBUG
            case .info:
                return .LOG
            case .warn:
                return .WARN
            case .error:
                return .ERROR
            @unknown default:
                fatalError()
            }
        }
    }
#else
struct AmplitudeWrapperImpl: EventTrackerManager, Manager {
    init(withKey key: String, amplitudeTrackingEnable: Bool = true, sessionReplayPluginEnabled: Bool = false) {
    }

    func sendEvent(_ event: KovaleeFramework.Event) {
    }
    
    func setUserId(_ userId: String) {
    }
    
    func setDeviceId(_ deviceId: String) {
    }
    
    func setUserProperty(key: String, value: String) {
    }
    
    func setUserProperty(property: KovaleeFramework.UserProperty) {
    }
    
    func setUserProperties(_ properties: [String : String]) {
    }
    
    func setDataCollectionEnabled(_ enabled: Bool) {
    }
    
    func getUserId() -> String? {
        nil
    }
    
    func getDeviceId() -> String? {
        nil
    }
}
#endif
