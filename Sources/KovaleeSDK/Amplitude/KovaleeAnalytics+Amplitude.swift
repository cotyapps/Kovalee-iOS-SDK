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
            withKey: configuration.environment == .production ? keys.amplitude.prodSDKId : (keys.amplitude.devSDKId ?? "")
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
    /// - Returns: number of times app has beeen opened
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

public extension Kovalee {
    /// Retrieves onboarding data for a specific user .
    ///
    /// This method fetches the onboarding data collected during the web onboarding associated with the provided user ID.
    ///
    /// - Parameters:
    ///   - userId: A `String` representing the ID of the user
    /// - Returns: A `UserOnboardingData?` containing the onboarding data for the user, or `nil` if no data is available
    /// - Throws: An error if the retrieval process fails.
    ///
    /// ```swift
    /// struct UserOnboardingData {
    ///		var userExists: Bool
    /// 	var onboardingCompleted: Bool
    /// 	var onboardingData: [String: String]
    /// }
    /// ```
    static func webOnboardingDataForUser(withId userId: String) async throws -> KovaleeManager.UserOnboardingData? {
        try await shared.kovaleeManager?.userOnboardingData(userId: userId)
    }
}

public enum TaggingPlanLiteEvent {
    case onboardingFinish
    case onboardingPageView(number: Int)
    case onboardingStart
    case pageViewPaywall(source: String) // onboarding (onboarding paywall) / in_content (paywall within the app/ not onboarding)
    case paymentSubscribe(name: String) // id of the product
    case paymentTrialStarted
    case paymentTrialConvert
    case acContentEngage
    case acClick(name: String) // name of the button

    var name: String {
        switch self {
        case .onboardingFinish:
            "onboarding_finish"
        case .onboardingPageView:
            "onboarding_page_view"
        case .onboardingStart:
            "onboarding_start"
        case .pageViewPaywall:
            "page_view_paywall"
        case .paymentSubscribe:
            "payment_subscribe"
        case .paymentTrialStarted:
            "payment_trial_started"
        case .paymentTrialConvert:
            "payment_trial_convert"
        case .acContentEngage:
            "ac_content_engage"
        case .acClick:
            "ac_click"
        }
    }

    var properties: [String: String]? {
        switch self {
        case let .onboardingPageView(number):
            ["number": "\(number)"]
        case let .pageViewPaywall(source):
            ["source": source]
        case let .paymentSubscribe(name):
            ["name": name]
        case let .acClick(name):
            ["name": name]
        default:
            nil
        }
    }
}

// MARK: Purchase accessory methods

public extension Kovalee {
    /// Use this method straight before starting a purchase
    ///
    /// - Parameters:
    ///    - duration: the subscription duration
    ///    - source: from where is the user making the purchase
    @available(swift, deprecated: 1.7.0, message: "Please migrate to paymentFailed method with SubscriptionId instead of Duration as input parameter")
    static func startedPurchasing(
        subscriptionWithDuration _: Duration,
        fromSource source: String
    ) {
        startedPurchasing(subscriptionWithProductId: "", fromSource: source)
    }

    /// Use this method straight before starting a purchase
    ///
    /// - Parameters:
    ///    - productId: the subscription Id
    ///    - source: from where is the user making the purchase
    @available(swift, introduced: 1.7.1)
    static func startedPurchasing(
        subscriptionWithProductId productId: String,
        fromSource source: String
    ) {
        shared.kovaleeManager?.startedPurchasing(subscriptionWithId: productId, fromSource: source)
    }

    /// Use this method straight after a purchase has been successfully executed
    ///
    /// - Parameters:
    ///    - productId: the id of the purchased subscription
    ///    - duration: the subscription duration
    ///    - source: from where is the user making the purchase
    static func succesfullyPurchased(
        subscriptionWithProductId productId: String,
        andDuration _: Duration,
        fromSource source: String
    ) {
        shared.kovaleeManager?.succesfullyPurchased(
            subscriptionWithProductId: productId,
            fromSource: source
        )
    }

    /// Use this method to tell the SDK a payment has been cancelled
    ///
    /// - Parameters:
    ///    - source: from where is the user making the purchase
    static func paymentCancelledForSubscription(fromSource source: String) {
        shared.kovaleeManager?.paymentCancelledForSubscription(fromSource: source)
    }

    /// Use this method to tell the SDK a subscription payment has failed
    ///
    /// - Parameters:
    ///    - duration: the subscription duration
    ///    - source: from where is the user making the purchase
    @available(swift, deprecated: 1.7.0, message: "Please migrate to paymentFailed method with SubscriptionId instead of Duration as input parameter")
    static func paymentFailed(
        forSubscriptionWithDuration _: Duration,
        fromSource source: String
    ) {
        paymentFailed(forSubscriptionWithId: "", fromSource: source)
    }

    /// Use this method to tell the SDK a subscription payment has failed
    ///
    /// - Parameters:
    ///    - productId: the subscription Id
    ///    - source: from where is the user making the purchase
    @available(swift, introduced: 1.7.1)
    static func paymentFailed(
        forSubscriptionWithId productId: String,
        fromSource source: String
    ) {
        shared.kovaleeManager?.paymentFailed(
            forSubscriptionWithId: productId,
            fromSource: source
        )
    }

    /// Use this method to tell the SDK a restore payment has failed
    ///
    /// - Parameters:
    ///    - source: from where is the user making the purchase
    static func paymentRestoredFailed(fromSource source: String) {
        shared.kovaleeManager?.paymentRestoredFailed(fromSource: source)
    }

    /// Use this method to tell the SDK a payment has startered restoring
    ///
    /// - Parameters:
    ///    - source: from where is the user making the purchase
    static func paymentRestoreStart(fromSource source: String) {
        shared.kovaleeManager?.paymentRestoredStart(fromSource: source)
    }

    /// Use this method to tell the SDK a payment has been restore successfully
    ///
    /// - Parameters:
    ///    - source: from where is the user making the purchase
    static func paymentRestored(fromSource source: String) {
        shared.kovaleeManager?.paymentRestored(fromSource: source)
    }

    /// Use this method to tell the SDK that the current user is or is not premum
    ///
    /// - Parameters:
    ///    - premium: is the user premium
    static func setIsUserPremium(_ premium: Bool) {
        shared.kovaleeManager?.setIsUserPremium(premium)
    }
}

/// Helper enum to map subscription duration to Int
public enum Duration {
    case day
    case month
    case week
    case year

    public static func create(fromIntValue value: Int) -> Self? {
        switch value {
        case 1:
            return .day
        case 7:
            return .week
        case 30:
            return .month
        case 365:
            return .year
        default:
            return nil
        }
    }

    public var inDays: Int {
        switch self {
        case .day:
            return 1
        case .month:
            return 30
        case .week:
            return 7
        case .year:
            return 365
        }
    }
}
