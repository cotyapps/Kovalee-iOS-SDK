#if os(iOS)
import Foundation
import SwiftUI

@available(iOS 17, *)
@MainActor
@Observable
class FeedbackFormViewModel {
    enum Step {
        case choices
        case notes
        case confirmation
    }

    // Step management
    var currentStep: Step = .choices

    // Form data
    var selectedChoices: Set<String> = []
    var notes: String = ""

    // UI properties
    var primaryColor: Color
    var secondaryColor: Color
    var backgroundColor: Color
    var secondaryBackgroundColor: Color
    var selectedColor: Color
    var unselectedColor: Color
    var ctaColor: Color
    var appIcon: Image
    var choices: [String]
    var onComplete: () -> Void

    // Step titles and subtitles
    var choicesTitle: String
    var choicesSubtitle: String
    var notesTitle: String
    var notesSubtitle: String
    var notesPlaceholder: String
    var confirmationTitle: String
    var confirmationMessage: String
    var feedbackMetadata: FeedbackMetadata
    var onChoicesButtonTapped: (() -> Void)?
    var onNotesActionTapped: (() -> Void)?

    init(
        primaryColor: Color,
        secondaryColor: Color,
        backgroundColor: Color,
        secondaryBackgroundColor: Color,
        ctaColor: Color,
        selectedColor: Color,
        unselectedColor: Color,
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
        onComplete: @escaping () -> Void,
        onChoicesButtonTapped: (() -> Void)? = nil,
        onNotesActionTapped: (() -> Void)? = nil
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.backgroundColor = backgroundColor
        self.secondaryBackgroundColor = secondaryBackgroundColor
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.ctaColor = ctaColor
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
        self.onComplete = onComplete
        self.onChoicesButtonTapped = onChoicesButtonTapped
        self.onNotesActionTapped = onNotesActionTapped
    }

    func selectChoice(_ choice: String) {
        if selectedChoices.contains(choice) {
            selectedChoices.remove(choice)
        } else {
            selectedChoices.insert(choice)
        }
    }

    func nextStep() {
        switch currentStep {
        case .choices:
            currentStep = .notes
        case .notes:
            currentStep = .confirmation
        case .confirmation:
            break
        }
    }

    func reset() {
        currentStep = .choices
        selectedChoices = []
        notes = ""
    }
}
#endif
