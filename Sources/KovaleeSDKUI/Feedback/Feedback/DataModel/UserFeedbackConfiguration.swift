#if os(iOS)
import SwiftUI

@available(iOS 17, *)
public struct UserFeedbackConfiguration: Sendable {
    public let feedbackText: FeedbackText
    public let feedbackStyle: FeedbackStyle
    public let feedbackMetadata: FeedbackMetadata
    public let secondaryButton: SecondaryButton?
    /// Cloud Functions region the `writeToSheet` callable is deployed to. `nil` uses Firebase's default (`us-central1`).
    public let firebaseRegion: String?

    public struct SecondaryButton: Sendable {
        public let text: String
        public let action: @Sendable () -> Void

        public init(text: String, action: @escaping @Sendable () -> Void) {
            self.text = text
            self.action = action
        }
    }

    public init(
        feedbackText: FeedbackText,
        feedbackStyle: FeedbackStyle = .default,
        feedbackMetadata: FeedbackMetadata,
        secondaryButton: SecondaryButton? = nil,
        firebaseRegion: String? = nil
    ) {
        self.feedbackText = feedbackText
        self.feedbackStyle = feedbackStyle
        self.feedbackMetadata = feedbackMetadata
        self.secondaryButton = secondaryButton
        self.firebaseRegion = firebaseRegion
    }
}


@available(iOS 17, *)
public struct FeedbackText: Sendable {
    public let cta: String
    public let title: String
	public let introText: String
	public let imageName: String
	public let successText: String

	public init(
        cta: String = "Continue",
        title: String = "",
		introText: String = "",
		imageName: String = "",
		successText: String = ""
	) {
        self.cta = cta
        self.title = title
		self.introText = introText
		self.imageName = imageName
		self.successText = successText
	}
}

@available(iOS 17, *)
public struct FeedbackStyle: Sendable {
	public let backgroundColor: Color
	public let textColor: Color
    public let titlesColor: Color
	public let fieldBackgroundColor: Color
	public let submitButtonColor: Color
    public var symbol: String?

	public init(
		backgroundColor: Color = Color.black,
		textColor: Color = Color.white,
        titlesColor: Color = Color.white,
		fieldBackgroundColor: Color = Color(UIColor.darkGray),
		submitButtonColor: Color = Color.red,
        symbol: String? = nil
	) {
		self.backgroundColor = backgroundColor
		self.textColor = textColor
        self.titlesColor = titlesColor
		self.fieldBackgroundColor = fieldBackgroundColor
		self.submitButtonColor = submitButtonColor
        self.symbol = symbol
	}

	/// Sensible out-of-the-box styling, so a host can present without configuring colors.
	public static let `default` = FeedbackStyle()
}

@available(iOS 17, *)
@MainActor
public struct FeedbackMetadata: Sendable {
	public let osVersion: String
	public let appVersion: String
	public let rcUserId: String
	public let amplitudeUserId: String
	public let subscriptionStatus: String
	
	public init(
		appVersion: String,
		rcUserId: String,
		amplitudeUserId: String,
		subscriptionStatus: String
	) {
		self.osVersion = UIDevice.current.systemVersion
		self.appVersion = appVersion
		self.rcUserId = rcUserId
		self.amplitudeUserId = amplitudeUserId
		self.subscriptionStatus = subscriptionStatus
	}
}

@available(iOS 17, *)
@MainActor
extension UserFeedbackConfiguration {
	static let mock = UserFeedbackConfiguration(
		feedbackText: FeedbackText(
			introText: "Hi, I'm Maryeme the founder of Alba. I've started this project after my first crisis of hormonal acne. I felt a bit lost among all products, ingredients and I also had no idea of my skin type.\n\nI worked during 2 years with dermatologists to help people like me having a better skin care routine. If you can take 1 minute to tell me what I can improve, it will definitely help 🤗",
			imageName: "feedback-image",
			successText: "Feedback received!"
		),
		feedbackStyle: FeedbackStyle(
			backgroundColor: .black,
			textColor: .white,
			fieldBackgroundColor: Color(UIColor.darkGray),
			submitButtonColor: .red
		),
		feedbackMetadata: FeedbackMetadata(
			appVersion: "1.0.0",
			rcUserId: "mock-rc-user-123",
			amplitudeUserId: "mock-amplitude-456",
			subscriptionStatus: "premium"
		)
	)
}
#endif
