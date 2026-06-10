#if os(iOS)
import SwiftUI

@available(iOS 17, *)
struct FeedbackDebugView: View {
    @State private var coordinator = FeedbackCoordinator()

    var body: some View {
        Button("Preview Founder Feedback") {
            coordinator.showFounder(
                text: FeedbackText(
                    introText: "This is a debug preview of the founder feedback flow. In production, replace this text with a personal message from the founder.",
                    imageName: "",
                    successText: "Thanks for your feedback!"
                )
            )
        }
        .buttonStyle(.bordered)
        .userFeedback(coordinator: coordinator)

        Button("Preview Feature Survey") {
            coordinator.showFeatures(
                text: FeatureFeedbackText(
                    choicesTitle: "What should we improve?",
                    choicesSubtitle: "Pick the features that matter most to you",
                    notesTitle: "Anything else?",
                    notesSubtitle: "Your extra feedback helps us prioritize",
                    notesPlaceholder: "Type here…",
                    confirmationTitle: "Thanks!",
                    confirmationMessage: "Your input helps us build a better product."
                ),
                appIcon: Image(systemName: "app.fill"),
                choices: ["Performance", "Design", "Notifications", "Onboarding", "Other"]
            )
        }
        .buttonStyle(.bordered)
    }
}
#endif
