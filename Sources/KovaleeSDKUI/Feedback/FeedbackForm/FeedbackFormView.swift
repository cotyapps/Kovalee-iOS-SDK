#if os(iOS)
import SwiftUI

@available(iOS 17, *)
public struct FeedbackFormView: View {
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    let secondaryBackgroundColor: Color
    let ctaColor: Color
    var selectedColor: Color
    var unselectedColor: Color
    let buttonCornerRadius: CGFloat
    let appIcon: Image
    let choices: [String]
    let choicesTitle: String
    let choicesSubtitle: String
    let notesTitle: String
    let notesSubtitle: String
    let notesPlaceholder: String
    let confirmationTitle: String
    let confirmationMessage: String
    let feedbackMetadata: FeedbackMetadata
    let firebaseRegion: String?
    let onComplete: () -> Void
    let onChoicesButtonTapped: (() -> Void)?
    let onNotesActionTapped: (() -> Void)?

    @State private var viewModel: FeedbackFormViewModel

    public init(
        primaryColor: Color,
        secondaryColor: Color,
        backgroundColor: Color,
        secondaryBackgroundColor: Color,
        ctaColor: Color,
        selectedColor: Color,
        unselectedColor: Color,
        buttonCornerRadius: CGFloat = 16,
        initialStepIndex: Int = 0,
        appIcon: Image,
        choices: [String],
        choicesTitle: String,
        choicesSubtitle: String,
        notesTitle: String,
        notesSubtitle: String,
        notesPlaceholder: String,
        confirmationTitle: String,
        confirmationMessage: String,
        feedbackMetadata: FeedbackMetadata,
        firebaseRegion: String? = nil,
        onComplete: @escaping () -> Void,
        onChoicesButtonTapped: (() -> Void)? = nil,
        onNotesActionTapped: (() -> Void)? = nil
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.backgroundColor = backgroundColor
        self.secondaryBackgroundColor = secondaryBackgroundColor
        self.ctaColor = ctaColor
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.buttonCornerRadius = buttonCornerRadius
        self.appIcon = appIcon
        self.choices = choices
        self.choicesTitle = choicesTitle
        self.choicesSubtitle = choicesSubtitle
        self.notesTitle = notesTitle
        self.notesSubtitle = notesSubtitle
        self.notesPlaceholder = notesPlaceholder
        self.confirmationTitle = confirmationTitle
        self.confirmationMessage = confirmationMessage
        self.feedbackMetadata = feedbackMetadata
        self.firebaseRegion = firebaseRegion
        self.onComplete = onComplete
        self.onChoicesButtonTapped = onChoicesButtonTapped
        self.onNotesActionTapped = onNotesActionTapped
        let model = FeedbackFormViewModel(
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            backgroundColor: backgroundColor,
            secondaryBackgroundColor: secondaryBackgroundColor,
            ctaColor: ctaColor,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            appIcon: appIcon,
            choices: choices,
            choicesTitle: choicesTitle,
            choicesSubtitle: choicesSubtitle,
            notesTitle: notesTitle,
            notesSubtitle: notesSubtitle,
            notesPlaceholder: notesPlaceholder,
            confirmationTitle: confirmationTitle,
            confirmationMessage: confirmationMessage,
            feedbackMetadata: feedbackMetadata,
            firebaseRegion: firebaseRegion,
            onComplete: onComplete,
            onChoicesButtonTapped: onChoicesButtonTapped,
            onNotesActionTapped: onNotesActionTapped
        )
        switch initialStepIndex {
        case 1: model.currentStep = .notes
        case 2: model.currentStep = .confirmation
        default: break
        }
        self._viewModel = State(initialValue: model)
    }

    public var body: some View {
        NavigationStack {
            Group {
                switch viewModel.currentStep {
                case .choices:
                    FeedbackChoicesView(
                        title: viewModel.choicesTitle,
                        subtitle: viewModel.choicesSubtitle,
                        choices: viewModel.choices,
                        titleColor: viewModel.primaryColor,
                        subtitleColor: viewModel.secondaryColor,
                        background: viewModel.backgroundColor,
                        cardBackground: viewModel.secondaryBackgroundColor,
                        ctaColor: viewModel.ctaColor,
                        selectedBackground: viewModel.ctaColor.opacity(0.06),
                        selectedText: viewModel.selectedColor,
                        unselectedText: viewModel.unselectedColor,
                        titleFont: .system(size: 30, weight: .bold),
                        subtitleFont: .system(size: 16, weight: .regular),
                        buttonFont: .headline.bold(),
                        buttonTitle: LocalizedStrings.featuresChoicesButton,
                        buttonCornerRadius: buttonCornerRadius,
                        onSubmit: { selected in
                            viewModel.selectedChoices = Set(selected)
                            viewModel.onChoicesButtonTapped?()
                            viewModel.nextStep()
                        }
                    )
                case .notes:
                    FeedbackNotesView()
                case .confirmation:
                    FeedbackConfirmationView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .animation(.easeInOut, value: viewModel.currentStep)
            .environment(viewModel)
        }
    }
}
#endif
