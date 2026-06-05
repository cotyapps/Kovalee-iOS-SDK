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
    /// Presents the founder (free-form) feedback flow, auto-filling `FeedbackMetadata`
    /// from the Kovalee SDK. The host only provides copy and (optionally) styling.
    @MainActor func showFounder(
        text: FeedbackText,
        style: FeedbackStyle = .default,
        showBackButton: Bool = true
    ) {
        Task { @MainActor in
            let metadata = await FeedbackMetadata.fromKovalee()
            showFounder(
                UserFeedbackConfiguration(
                    feedbackText: text,
                    feedbackStyle: style,
                    feedbackMetadata: metadata
                ),
                showBackButton: showBackButton
            )
        }
    }

    /// Presents the multi-choice "features" survey, auto-filling `FeedbackMetadata`
    /// from the Kovalee SDK. The host only provides copy, icon, choices, and styling.
    @MainActor func showFeatures(
        text: FeatureFeedbackText,
        appIcon: Image,
        choices: [String],
        style: FeatureFeedbackStyle = .default,
        onChoicesButtonTapped: (@Sendable () -> Void)? = nil,
        onNotesActionTapped: (@Sendable () -> Void)? = nil
    ) {
        Task { @MainActor in
            let metadata = await FeedbackMetadata.fromKovalee()
            showFeatures(
                FeatureFeedbackConfiguration(
                    style: style,
                    text: text,
                    appIcon: appIcon,
                    choices: choices,
                    metadata: metadata,
                    onChoicesButtonTapped: onChoicesButtonTapped,
                    onNotesActionTapped: onNotesActionTapped
                )
            )
        }
    }
}
#endif
