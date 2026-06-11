#if os(iOS)
import SwiftUI

@available(iOS 17, *)
@MainActor
@Observable
public final class FeedbackCoordinator {
    public enum Presentation: Identifiable {
        case founder(UserFeedbackConfiguration, showBackButton: Bool)
        case features(FeatureFeedbackConfiguration)

        public var id: String {
            switch self {
            case .founder: return "founder"
            case .features: return "features"
            }
        }
    }

    public var presentation: Presentation?

    public init() {}

    public func showFounder(
        _ configuration: UserFeedbackConfiguration,
        showBackButton: Bool = true
    ) {
        presentation = .founder(configuration, showBackButton: showBackButton)
    }

    public func showFeatures(_ configuration: FeatureFeedbackConfiguration) {
        presentation = .features(configuration)
    }

    public func dismiss() {
        presentation = nil
    }
}

@available(iOS 17, *)
public extension View {
    func userFeedback(coordinator: FeedbackCoordinator) -> some View {
        modifier(UserFeedbackPresenter(coordinator: coordinator))
    }
}

@available(iOS 17, *)
private struct UserFeedbackPresenter: ViewModifier {
    @Bindable var coordinator: FeedbackCoordinator

    func body(content: Content) -> some View {
        content.sheet(item: $coordinator.presentation) { presentation in
            switch presentation {
            case let .founder(config, showBack):
                UserFeedbackView(configuration: config, showBackButton: showBack)
            case let .features(config):
                FeedbackFormView(
                    primaryColor: config.style.primaryColor,
                    secondaryColor: config.style.secondaryColor,
                    backgroundColor: config.style.backgroundColor,
                    secondaryBackgroundColor: config.style.secondaryBackgroundColor,
                    ctaColor: config.style.ctaColor,
                    selectedColor: config.style.selectedColor,
                    unselectedColor: config.style.unselectedColor,
                    buttonCornerRadius: config.style.buttonCornerRadius,
                    appIcon: config.appIcon,
                    choices: config.choices,
                    choicesTitle: config.text.choicesTitle,
                    choicesSubtitle: config.text.choicesSubtitle,
                    notesTitle: config.text.notesTitle,
                    notesSubtitle: config.text.notesSubtitle,
                    notesPlaceholder: config.text.notesPlaceholder,
                    confirmationTitle: config.text.confirmationTitle,
                    confirmationMessage: config.text.confirmationMessage,
                    feedbackMetadata: config.metadata,
                    onComplete: { coordinator.dismiss() },
                    onChoicesButtonTapped: config.onChoicesButtonTapped,
                    onNotesActionTapped: config.onNotesActionTapped
                )
            }
        }
    }
}
#endif
