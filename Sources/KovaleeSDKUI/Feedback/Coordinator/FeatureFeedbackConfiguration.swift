#if os(iOS)
import SwiftUI

@available(iOS 17, *)
public struct FeatureFeedbackText: Sendable {
    public var choicesTitle: String
    public var choicesSubtitle: String
    public var notesTitle: String
    public var notesSubtitle: String
    public var notesPlaceholder: String
    public var confirmationTitle: String
    public var confirmationMessage: String

    public init(
        choicesTitle: String,
        choicesSubtitle: String,
        notesTitle: String,
        notesSubtitle: String,
        notesPlaceholder: String,
        confirmationTitle: String,
        confirmationMessage: String
    ) {
        self.choicesTitle = choicesTitle
        self.choicesSubtitle = choicesSubtitle
        self.notesTitle = notesTitle
        self.notesSubtitle = notesSubtitle
        self.notesPlaceholder = notesPlaceholder
        self.confirmationTitle = confirmationTitle
        self.confirmationMessage = confirmationMessage
    }
}

@available(iOS 17, *)
public struct FeatureFeedbackConfiguration: Sendable {
    public var style: FeedbackStyle
    public var text: FeatureFeedbackText
    public var appIcon: Image
    public var choices: [String]
    public var metadata: FeedbackMetadata
    /// Cloud Functions region the `sendForm` callable is deployed to. `nil` uses Firebase's default (`us-central1`).
    public var firebaseRegion: String?
    public var onChoicesButtonTapped: (@Sendable () -> Void)?
    public var onNotesActionTapped: (@Sendable () -> Void)?

    public init(
        style: FeedbackStyle = .default,
        text: FeatureFeedbackText,
        appIcon: Image,
        choices: [String],
        metadata: FeedbackMetadata,
        firebaseRegion: String? = nil,
        onChoicesButtonTapped: (@Sendable () -> Void)? = nil,
        onNotesActionTapped: (@Sendable () -> Void)? = nil
    ) {
        self.style = style
        self.text = text
        self.appIcon = appIcon
        self.choices = choices
        self.metadata = metadata
        self.firebaseRegion = firebaseRegion
        self.onChoicesButtonTapped = onChoicesButtonTapped
        self.onNotesActionTapped = onNotesActionTapped
    }
}
#endif
