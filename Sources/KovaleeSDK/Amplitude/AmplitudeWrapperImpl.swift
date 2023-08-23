import AmplitudeSwift
import Foundation
import KovaleeFramework

struct AmplitudeWrapperImpl: EventTrackerManager, Manager {
    init(withKey key: String) {
		KLogger.debug("initializing Amplitude")

        let trackingOptions = TrackingOptions()
            .disableTrackIpAddress()
            .disableCarrier()
            .disableTrackCity()

        amplitude = Amplitude(
            configuration: AmplitudeSwift.Configuration(
                apiKey: key,
                logLevel: KLogger.logLevel.amplitudeLogLevel(),
                callback: { event, code, message in
                    KLogger.debug("\(code): \(message) → \(event.description)")
                },
                trackingOptions: trackingOptions,
                flushEventsOnClose: true
            )
        )
    }

    func sendEvent(_ event: Event) {
		guard let amplitude else {
			KLogger.error("Failed sending Event: \(event.name) \(event.properties?.serialization ?? "")")
			return
		}

        amplitude.track(
            eventType: event.name,
            eventProperties: event.properties ?? [:]
        )
        KLogger.debug("Sending Event: \(event.name) \(event.properties?.serialization ?? "")")
    }

    func setUserId(_ userId: String) {
        amplitude?.setUserId(userId: userId)

        KLogger.debug("Setting userId: \(userId)")
    }

    func setDeviceId(_ deviceId: String) {
        amplitude?.setDeviceId(deviceId: deviceId)

        KLogger.debug("Setting deviceId: \(deviceId)")
    }

    func setUserProperty(key: String, value: String) {
        amplitude?.identify(
            identify: Identify().set(property: key, value: value)
        )

        KLogger.debug("Setting user property: \(key) → \(value)")
    }

    func setUserProperty(property: UserProperty) {
        self.setUserProperty(key: property.key, value: property.value)
    }

	func getUserId() -> String? {
		amplitude?.getUserId()
	}

	func getDeviceId() -> String? {
		amplitude?.getDeviceId()
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
		@unknown default:
			fatalError()
		}
    }
}
