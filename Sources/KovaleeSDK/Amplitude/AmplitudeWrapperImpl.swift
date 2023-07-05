import Foundation
import KovaleeFramework
import Amplitude_Swift

struct AmplitudeConfiguration {
    var token: String
}

struct AmplitudeWrapperImpl: AmplitudeWrapper {
    init(withConfiguration configuration: AmplitudeConfiguration) {
		Logger.debug("initializing Amplitude")

        let trackingOptions = TrackingOptions()
            .disableTrackIpAddress()
            .disableCarrier()
            .disableTrackCity()
            .disableTrackLatLng()

        amplitude = Amplitude(
            configuration: Amplitude_Swift.Configuration(
                apiKey: configuration.token,
                logLevel: Logger.logLevel.amplitudeLogLevel(),
                callback: { event, code, message in
                    Logger.debug("\(code): \(message) → \(event.description)")
                },
                trackingOptions: trackingOptions,
                flushEventsOnClose: true
            )
        )

        amplitude?.add(plugin: IDFACollectionPlugin())
    }

    func sendEvent(_ event: Event) {
        amplitude?.track(
            eventType: event.name,
            eventProperties: event.properties ?? [:]
        )
        Logger.debug("Sending Event: \(event.name) \(event.properties?.serialization ?? "")")
    }

    func setUserId(_ userId: String) {
        amplitude?.setUserId(userId: userId)

        Logger.debug("Setting userId: \(userId)")
    }

    func setDeviceId(_ deviceId: String) {
        amplitude?.setDeviceId(deviceId: deviceId)

        Logger.debug("Setting deviceId: \(deviceId)")
    }

    func setUserProperty(key: String, value: String) {
        amplitude?.identify(
            identify: Identify().set(property: key, value: value)
        )

        Logger.debug("Setting user property: \(key) → \(value)")
    }

    func setUserProperty(property: UserProperty) {
        self.setUserProperty(key: property.key, value: property.value)
    }

    var amplitude: Amplitude?
}

extension BaseEvent {
    var description: String {
        guard let properties = self.eventProperties else {
            return self.eventType
        }

        return self.eventType + " " + properties.description
    }
}

extension LogLevel {
    func amplitudeLogLevel() -> LogLevelEnum {
        switch self {
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
        }
    }
}
