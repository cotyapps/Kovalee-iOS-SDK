import Foundation
import KovaleeFramework

extension EventsTrackerManagerCreator: Creator {
    public func createImplementation(
        withConfiguration configuration: Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager {
        if configuration.environment == .development && keys.amplitude.devSDKId == nil {
            KLogger.error("Configured Sandbox environment but Amplitude Dev key hasn't been provided")
        }
        return AmplitudeWrapperImpl(
            withKey: configuration.environment == .production ? keys.amplitude.prodSDKId : (keys.amplitude.devSDKId ?? ""),
            amplitudeTrackingEnable: configuration.environment == .production ? true : configuration.forceAmplitudeDebugLogging
        )
    }
}

// MARK: Event Tracking

public extension Kovalee {
    /// Returns the date when the app has been installed in the current device
    ///
    /// - Returns: date of the app installation in current device
    static func appInstallationDate() -> Date? {
        shared.kovaleeManager?.installationDate()
    }

    /// Returns the number of times the app has been opened
    ///
    /// - Returns: number of times app has been opened
    static func appOpeningCount() -> Int {
        shared.kovaleeManager?.appOpeningCount() ?? 0
    }

    /// Disable any data collection for this specific user
    ///
    /// - Parameters:
    ///    - enabled: a boolean stating if data about the user should be collected
    static func setDataCollectionEnabled(_ enabled: Bool) {
        KLogger.debug("Opt \(enabled ? "in" : "out") user from collecting data")
        shared.kovaleeManager?.setDataCollectionEnabled(enabled)
    }

    /// Returns a boolean stating if the data about the current user is currently collected
    ///
    /// - Returns: a boolean stating if data about the user is currently collected
    static func isDataCollectionEnabled() -> Bool {
        shared.kovaleeManager?.isDataCollectionEnabled() ?? true
    }

    /// Send an ``Event``
    ///
    /// This method is used to track a specific user behaviour, like interaction with a button.
    /// ``` Swift
    /// Kovalee.sendEvent(Event(name: "create_list"))
    /// ```
    ///
    /// It can also be used to track an app behaviour, like displaying a specific View.
    /// ``` Swift
    /// Kovalee.sendEvent(Event(name: "page_view", properties: ["name": "list"]))
    /// ```
    ///
    /// - Parameters:
    ///    - event: the event that is going to be sent
    static func sendEvent(_ event: Event) {
        shared.kovaleeManager?.sendEvent(event)
    }

    /// Send an ``Event``
    ///
    /// This method is used to track a specific user behaviour, like interaction with a button.
    /// ``` Swift
    /// Kovalee.sendEvent(withName: "create_list")
    /// ```
    ///
    /// It can also be used to track an app behaviour, like displaying a specific View.
    /// ``` Swift
    /// Kovalee.sendEvent(withName: "page_view", andProperties: ["name": "list"])
    /// ```
    ///
    /// - Parameters:
    ///    - name: the name of the event that is going to be sent
    ///    - properties: the properties of the event that is going to be sent
    static func sendEvent(
        withName name: String,
        andProperties properties: [String: any Sendable]? = nil
    ) {
        shared.kovaleeManager?.sendEvent(Event(name: name, properties: properties))
    }

    /// Set a specific userId for Amplitude
    ///
    /// The same deviceId will be set also for RevenueCat amplitude user id attribute
    ///
    /// - Parameters:
    ///    - userId: a string representing the userId to be set
    static func setAmplitudeUserId(userId: String) {
        shared.kovaleeManager?.setAmplitudeUserId(userId: userId)
    }

    /// Associate a new property to the current user.
    ///
    /// - Parameters:
    ///    - key: key to recognise the property
    ///    - value: value of the user property
    static func setUserProperty(key: String, value: String) {
        shared.kovaleeManager?.setUserProperty(key: key, value: value)
    }

    /// Associate a dictionary of properties to the current user.
    ///
    /// - Parameters:
    ///    - properties: key-value dictionary of user properties
    static func setUserProperties(_ properties: [String: String]) {
        shared.kovaleeManager?.setUserProperties(properties)
    }

    /// Send a ``BasicEvent``
    ///
    /// This method is used to track one of the events in the ``BasicEvent`` enumeration
    /// ``` Swift
    /// Kovalee.sendEvent(event: .pageView(screen: "home"))
    /// ```
    ///
    /// - Parameters:
    ///    - event: the event that is going to be sent
    static func sendEvent(event: BasicEvent) {
        sendEvent(Event(name: event.name, properties: event.properties))
    }

    /// Send a ``TaggingPlanLiteEvent``
    ///
    /// This method is used to track one of the events in the ``TaggingPlanLiteEvent`` enumeration
    /// ``` Swift
    /// Kovalee.sendEvent(event: .onboardingPageView(number: 4))
    /// ```
    ///
    /// - Parameters:
    ///    - event: the event that is going to be sent
    static func sendEvent(event: TaggingPlanLiteEvent) {
        sendEvent(Event(name: event.name, properties: event.properties))
    }

    /// Retrieve the userId set in amplitude
    ///
    /// - Returns: the user id set in amplitude
    static func getAmplitudeUserId() -> String? {
        shared.kovaleeManager?.amplitudeUserId()
    }

    /// Retrieve the deviceId set in amplitude
    ///
    /// - Returns: the device id set in amplitude
    static func getAmplitudeDeviceId() -> String? {
        shared.kovaleeManager?.amplitudeDeviceId()
    }
}
