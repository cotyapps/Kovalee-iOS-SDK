#if os(iOS)
import KovaleePurchases
import KovaleeSDK
import SwiftUI

@available(iOS 17, *)
public extension FeedbackMetadata {
    /// Builds feedback metadata from the live Kovalee SDK state — RevenueCat user id,
    /// Amplitude user id, and premium status — so hosts don't hand-wire it.
    @MainActor static func fromKovalee() async -> FeedbackMetadata {
        let isPremium = (try? await Kovalee.isUserPremium()) ?? false
        return FeedbackMetadata(
            appVersion: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
            rcUserId: Kovalee.revenueCatUserId(),
            amplitudeUserId: Kovalee.getAmplitudeUserId() ?? "",
            subscriptionStatus: isPremium ? "premium" : "free"
        )
    }
}

@available(iOS 17, *)
public extension FeedbackCoordinator {
    /// Presents the founder (free-form) feedback flow using ``KovaleeUI/configuration``.
    @MainActor func showFounder(showBackButton: Bool = true) {
        Task { @MainActor in
            let metadata = await FeedbackMetadata.fromKovalee()
            showFounder(
                UserFeedbackConfiguration(
                    feedbackText: KovaleeUI.configuration.founderFeedbackText,
                    feedbackStyle: KovaleeUI.configuration.feedbackStyle,
                    feedbackMetadata: metadata
                ),
                showBackButton: showBackButton
            )
        }
    }

    /// Presents the multi-choice feature survey using ``KovaleeUI/configuration``.
    @MainActor func showFeatures(
        onChoicesButtonTapped: (@Sendable () -> Void)? = nil,
        onNotesActionTapped: (@Sendable () -> Void)? = nil
    ) {
        Task { @MainActor in
            let metadata = await FeedbackMetadata.fromKovalee()
            guard let featureFeedbackText = KovaleeUI.configuration.featureFeedbackText else {
                assertionFailure("""
                    KovaleeUI.configuration.featureFeedbackText must be set before calling showFeatures().
                    Set it once at app launch, e.g.:
                    KovaleeUI.configuration.featureFeedbackText = FeatureFeedbackText(
                        choicesTitle: "What do you want next?",
                        choicesSubtitle: "Help us shape the app.",
                        notesTitle: "Anything Else?",
                        notesSubtitle: "Share any other thoughts.",
                        notesPlaceholder: "Type here…",
                        confirmationTitle: "Feedback Received",
                        confirmationMessage: "Thanks for your input."
                    )
                    """)
                return
            }
            showFeatures(
                FeatureFeedbackConfiguration(
                    style: KovaleeUI.configuration.feedbackStyle,
                    text: featureFeedbackText,
                    appIcon: KovaleeUI.configuration.appIcon,
                    choices: KovaleeUI.configuration.feedbackChoices,
                    metadata: metadata,
                    onChoicesButtonTapped: onChoicesButtonTapped,
                    onNotesActionTapped: onNotesActionTapped
                )
            )
        }
    }
}
#endif
