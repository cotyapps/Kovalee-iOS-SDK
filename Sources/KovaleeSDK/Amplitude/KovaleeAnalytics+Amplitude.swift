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
	public static func sendEvent(
		withName name: String,
		andProperties properties: [String : Any]? = nil
	) {
		Self.shared.kovaleeManager?.sendEvent(Event(name: name, properties: properties))
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

	/// Retrieve the userId set in amplitude
	///
	/// - Returns: the user id set in amplitude
	public static func getAmplitudeUserId() -> String? {
		Self.shared.kovaleeManager?.amplitudeUserId()
	}

	/// Retrieve the deviceId set in amplitude
	///
	/// - Returns: the device id set in amplitude
	public static func getAmplitudeDeviceId() -> String? {
		Self.shared.kovaleeManager?.amplitudeDeviceId()
	}
}

// MARK: Purchase accessory methods
extension Kovalee {

	/// Use this method straight before starting a purchase
	///
	/// - Parameters:
	///    - duration: the subscription duration
	///    - source: from where is the user making the purchase
	public static func startedPurchasing(
		subscriptionWithDuration duration: Int,
		fromSource source: String
	) {
		Self.shared.kovaleeManager?.startedPurchasing(subscriptionWithDuration: duration, fromSource: source)
	}

	/// Use this method straight after a purchase has been successfully executed
	///
	/// - Parameters:
	///    - productId: the id of the purchased subscription
	///    - duration: the subscription duration
	///    - source: from where is the user making the purchase
	public static func succesfullyPurchased(
		subscriptionWithProductId productId: String,
		andDuration duration: Int,
		fromSource source: String
	) {
		Self.shared.kovaleeManager?.succesfullyPurchased(
			subscriptionWithProductId: productId,
			andDuration: duration,
			fromSource: source
		)
	}

	/// Use this method to tell the SDK a payment has been cancelled
	///
	/// - Parameters:
	///    - source: from where is the user making the purchase
	public static func paymentCancelledForSubscription(fromSource source: String) {
		Self.shared.kovaleeManager?.paymentCancelledForSubscription(fromSource: source)
	}

	/// Use this method to tell the SDK a subscription payment has failed
	///
	/// - Parameters:
	///    - duration: the subscription duration
	///    - source: from where is the user making the purchase
	public static func paymentFailed(
		forSubscriptionWithDuration duration: Int,
		fromSource source: String
	) {
		Self.shared.kovaleeManager?.paymentFailed(forSubscriptionWithDuration: duration, fromSource: source)
	}

	/// Use this method to tell the SDK a restore payment has failed
	///
	/// - Parameters:
	///    - source: from where is the user making the purchase
	public static func paymentRestoredFailed(fromSource source: String) {
		Self.shared.kovaleeManager?.paymentRestoredFailed(fromSource: source)
	}

	/// Use this method to tell the SDK a payment has startered restoring
	///
	/// - Parameters:
	///    - source: from where is the user making the purchase
	public static func paymentRestoreStart(fromSource source: String) {
		Self.shared.kovaleeManager?.paymentRestoredStart(fromSource: source)
	}

	/// Use this method to tell the SDK a payment has been restore successfully
	///
	/// - Parameters:
	///    - source: from where is the user making the purchase
	public static func paymentRestored(fromSource source: String) {
		Self.shared.kovaleeManager?.paymentRestored(fromSource: source)
	}

	/// Use this method to tell the SDK that the current user is or is not premum
	///
	/// - Parameters:
	///    - premium: is the user premium
	public static func setIsUserPremium(_ premium: Bool) {
		Self.shared.kovaleeManager?.setIsUserPremium(premium)
	}
}

