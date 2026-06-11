#if os(iOS)
import SwiftUI

/// Single configuration entry point for the KovaleeSDKUI feedback flows.
///
/// Set properties once at app launch before presenting any feedback view:
/// ```swift
/// KovaleeUI.configuration.appIcon        = Image("AppIcon")
/// KovaleeUI.configuration.feedbackChoices = ["Performance", "Design", "Notifications"]
/// KovaleeUI.configuration.founderFeedbackText = FeedbackText(introText: "Hi, I'm…", …)
/// KovaleeUI.configuration.featureFeedbackText = FeatureFeedbackText(choicesTitle: "…", …)
/// ```
///
/// Then present without repeating any configuration at the call site:
/// ```swift
/// coordinator.showFounder()
/// coordinator.showFeatures()
/// ```
@available(iOS 17, *)
public enum KovaleeUI {
    @MainActor public static var configuration = Configuration()

    public struct Configuration {
        /// The app's icon, shown in the feature-survey confirmation screen.
        public var appIcon: Image = Image(systemName: "app.fill")
        /// Choices presented in the feature-survey step.
        public var feedbackChoices: [String] = []
        /// Copy for the founder-feedback sheet. Defaults to ``FeedbackText/preview``.
        public var founderFeedbackText: FeedbackText = .preview
        /// Styling for both feedback sheets. Defaults to ``FeedbackStyle/default``.
        public var feedbackStyle: FeedbackStyle = .default
        /// Copy for the feature-survey sheet. Defaults to ``FeatureFeedbackText/preview``.
        public var featureFeedbackText: FeatureFeedbackText?
    }
}
#endif
