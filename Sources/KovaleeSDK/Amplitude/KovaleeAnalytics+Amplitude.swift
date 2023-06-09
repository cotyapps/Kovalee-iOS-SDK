import Foundation
import KovaleeFramework

// MARK: Amplitude
extension Kovalee {
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
    public static func sendEvent(_ event: Event) {
		Self.shared.kovaleeManager?.sendEvent(event)
    }

    /// Set a specific userId for Amplitude
    ///
    /// The same deviceId will be set also for RevenueCat amplitude user id attribute
    ///
    /// - Parameters:
    ///    - userId: a string representing the userId to be set
    public static func setAmplitudeUserId(userId: String) {
		Self.shared.kovaleeManager?.setAmplitudeUserId(userId: userId)
    }

    /// Associate a new property to the current user.
    ///
    /// - Parameters:
    ///    - key: key to recognise the property
    ///    - value: value of the user property
    public static func setUserProperty(key: String, value: String) {
        Self.shared.kovaleeManager?.setUserProperty(key: key, value: value)
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
    public static func sendEvent(event: BasicEvent) {
        Self.sendEvent(Event(name: event.name, properties: event.properties))
    }
}
