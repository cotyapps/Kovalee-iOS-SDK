#if os(iOS)
import SwiftUI

@available(iOS 17, *)
public struct UserFeedbackConfiguration: Sendable {
    public let feedbackText: FeedbackText
    public let feedbackStyle: KovaleeUIStyle
    public let feedbackMetadata: FeedbackMetadata
    public let secondaryButton: SecondaryButton?

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
        feedbackStyle: KovaleeUIStyle = .default,
        feedbackMetadata: FeedbackMetadata,
        secondaryButton: SecondaryButton? = nil
    ) {
        self.feedbackText = feedbackText
        self.feedbackStyle = feedbackStyle
        self.feedbackMetadata = feedbackMetadata
        self.secondaryButton = secondaryButton
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

/// Shared visual styling for the feedback sheets **and** the subscription-upsell
/// post-purchase screens. Partners configure it once via
/// ``KovaleeUI/Configuration/style`` and both surfaces honor it.
///
/// The color fields drive every surface; the `title`/`body`/`button` fonts and
/// the two `…Icon` SF Symbols are only consumed by the upsell post-purchase
/// screens (the feedback sheets use their own fixed typography). All fields are
/// defaulted, so a host can present without configuring anything.
public struct KovaleeUIStyle: Sendable {
    // Colors shared by the feedback sheets and the upsell post-purchase screens,
    // ordered to mirror the legacy `SubscriptionUpsell.Theme`
    // (`background`/`titleColor`/`bodyColor`/`primaryButtonBackground`) so the
    // migration is a rename-in-place.
    public var backgroundColor: Color
    public var primaryColor: Color
    public var secondaryColor: Color
    public var ctaColor: Color
    // Feedback-sheet-only colors.
    public var secondaryBackgroundColor: Color
    public var selectedColor: Color
    public var unselectedColor: Color
    public var buttonCornerRadius: CGFloat
    public var symbol: String?
    // Upsell post-purchase screens only.
    public var titleFont: Font
    public var bodyFont: Font
    public var buttonFont: Font
    /// SF Symbol shown above the "Lifetime unlocked" confirmation step.
    public var confirmationIcon: String
    /// SF Symbol shown above the "One last step" cancel-prompt step. Kept
    /// separate from `confirmationIcon` so the celebratory icon doesn't carry
    /// over into the more cautionary "turn off auto-renewal" screen.
    public var cancelPromptIcon: String

    public init(
        backgroundColor: Color = Color(.systemBackground),
        primaryColor: Color = .primary,
        secondaryColor: Color = .secondary,
        ctaColor: Color = .accentColor,
        secondaryBackgroundColor: Color = Color(.secondarySystemBackground),
        selectedColor: Color = .primary,
        unselectedColor: Color = .primary,
        buttonCornerRadius: CGFloat = 16,
        symbol: String? = nil,
        titleFont: Font = .system(size: 32, weight: .semibold),
        bodyFont: Font = .body,
        buttonFont: Font = .headline,
        confirmationIcon: String = "checkmark.seal.fill",
        cancelPromptIcon: String = "exclamationmark.circle.fill"
    ) {
        self.backgroundColor = backgroundColor
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.ctaColor = ctaColor
        self.secondaryBackgroundColor = secondaryBackgroundColor
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.buttonCornerRadius = buttonCornerRadius
        self.symbol = symbol
        self.titleFont = titleFont
        self.bodyFont = bodyFont
        self.buttonFont = buttonFont
        self.confirmationIcon = confirmationIcon
        self.cancelPromptIcon = cancelPromptIcon
    }

    /// Sensible out-of-the-box styling, so a host can present without configuring colors.
    public static let `default` = KovaleeUIStyle()
}

@available(iOS 17, *)
public extension FeedbackText {
    /// Sample copy for SwiftUI previews and debug builds.
    static let preview = FeedbackText(
        introText: "This is a preview of the founder feedback flow. In production, replace this with a personal message from the founder.",
        imageName: "",
        successText: "Thanks for your feedback!"
    )
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
		feedbackStyle: KovaleeUIStyle(
			backgroundColor: .black,
			primaryColor: .white,
			secondaryColor: .white,
			ctaColor: .red,
			secondaryBackgroundColor: Color(UIColor.darkGray)
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
