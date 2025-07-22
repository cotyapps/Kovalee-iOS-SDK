import KovaleeFramework

// MARK: Onboarding accessory methods

public extension Kovalee {
    /// Send an onboarding start event
    ///
    /// This method is used to track when a user begins the onboarding process.
    /// ``` Swift
    /// Kovalee.sendOnboardingStartEvent()
    /// ```
    static func sendOnboardingStartEvent() {
        sendEvent(event: .onboardingStart)
    }

    /// Send an onboarding finish event
    ///
    /// This method is used to track when a user completes the onboarding process.
    /// ``` Swift
    /// Kovalee.sendOnboardingFinishEvent()
    /// ```
    static func sendOnboardingFinishEvent() {
        sendEvent(event: .onboardingFinish)
    }

    /// Send an onboarding page view event
    ///
    /// This method is used to track when a user views a specific page during onboarding.
    /// ``` Swift
    /// Kovalee.sendOnboardingPageViewEvent(number: 0, totalPages: 5) // First page of 5
    /// Kovalee.sendOnboardingPageViewEvent(number: 3, totalPages: 5) // Fourth page of 5
    /// ```
    ///
    /// - Parameters:
    ///    - number: the page number being viewed during onboarding (0-indexed, where 0 is the first page)
    ///    - totalPages: the total number of pages in the onboarding flow
    static func sendOnboardingPageViewEvent(number: Int, totalPages: Int) {
        sendEvent(event: .onboardingPageView(number: number, totalPages: totalPages))
    }

    /// Set onboarding data for the current user
    ///
    /// This method is used to associate onboarding-related properties with the current user.
    /// ``` Swift
    /// Kovalee.setOnboardingData(["gender": "female", "age": "25-34"])
    /// ```
    ///
    /// - Parameters:
    ///    - data: key-value dictionary of onboarding data to associate with the user
    static func setOnboardingData(_ data: [String: String]) {
        setUserProperties(data)
    }

    /// Set the gender property for the current user
    ///
    /// This method is used to associate a gender property with the current user.
    /// ``` Swift
    /// Kovalee.setUserGender("female")
    /// ```
    ///
    /// - Parameters:
    ///    - gender: a string representing the user's gender
    static func setUserGender(_ gender: String) {
        setUserProperty(key: "gender", value: gender)
    }

    /// Set the age property for the current user
    ///
    /// This method is used to associate an age property with the current user.
    /// ``` Swift
    /// Kovalee.setUserAge("25")
    /// Kovalee.setUserAge("25-34")
    /// ```
    ///
    /// - Parameters:
    ///    - age: a string representing the user's age or age range
    static func setUserAge(_ age: String) {
        setUserProperty(key: "age", value: age)
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
    case onboardingPageView(number: Int, totalPages: Int)
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
        case let .onboardingPageView(number, total):
            ["number": "\(number)", "total": "\(total)"]
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
