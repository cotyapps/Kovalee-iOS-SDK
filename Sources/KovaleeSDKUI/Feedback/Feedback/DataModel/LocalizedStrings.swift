#if os(iOS)
import Foundation

// MARK: - Localized Strings Helper
@available(iOS 17, *)
public enum LocalizedStrings {
	
	// MARK: - Intro View
	static let feedbackIntroTitle = NSLocalizedString("feedback.intro.title", tableName: "Feedback", bundle: .module, comment: "intro title")
	static let feedbackIntroButton = NSLocalizedString("feedback.intro.button", tableName: "Feedback", bundle: .module, comment: "Intro Button")
	
	
	// MARK: - Form View
	static let feedbackTitle = NSLocalizedString("feedback.title", tableName: "Feedback", bundle: .module, comment: "Main title for feedback view")
	
	// MARK: - Form Fields
	static let emailTitle = NSLocalizedString("feedback.email.title", tableName: "Feedback", bundle: .module, comment: "Email field title")
	static let emailPlaceholder = NSLocalizedString("feedback.email.placeholder", tableName: "Feedback", bundle: .module, comment: "Email field placeholder")
	static let phoneTitle = NSLocalizedString("feedback.phone.title", tableName: "Feedback", bundle: .module, comment: "Phone field title")
	static let phonePlaceholder = NSLocalizedString("feedback.phone.placeholder", tableName: "Feedback", bundle: .module, comment: "Phone field placeholder")
	static let messageTitle = NSLocalizedString("feedback.message.title", tableName: "Feedback", bundle: .module, comment: "Message field title")
	static let messagePlaceholder = NSLocalizedString("feedback.message.placeholder", tableName: "Feedback", bundle: .module, comment: "Message field placeholder")
	
	// MARK: - Actions
	static let closeButton = NSLocalizedString("feedback.close.button", tableName: "Feedback", bundle: .module, value: "Close", comment: "Close button accessibility label")
	static let submitButton = NSLocalizedString("feedback.submit.button", tableName: "Feedback", bundle: .module, comment: "Submit button text")
	static let sendingMessage = NSLocalizedString("feedback.sending.message", tableName: "Feedback", bundle: .module, comment: "Loading message while sending")
	
	// MARK: - Success
	static let successTitle = NSLocalizedString("feedback.success.title", tableName: "Feedback", bundle: .module, comment: "Success alert title")
	static let successButton = NSLocalizedString("feedback.success.button", tableName: "Feedback", bundle: .module, comment: "Success alert button")

	// MARK: - Error
	static let errorTitle = NSLocalizedString("feedback.error.title", tableName: "Feedback", bundle: .module, value: "Couldn't send feedback", comment: "Error alert title shown when a feedback submission fails")
	static let errorMessage = NSLocalizedString("feedback.error.message", tableName: "Feedback", bundle: .module, value: "Something went wrong. Please check your connection and try again.", comment: "Error alert message shown when a feedback submission fails")
	static let errorRetryButton = NSLocalizedString("feedback.error.retry", tableName: "Feedback", bundle: .module, value: "Try again", comment: "Retry button in the submission error alert")
	static let errorCancelButton = NSLocalizedString("feedback.error.cancel", tableName: "Feedback", bundle: .module, value: "Cancel", comment: "Cancel button in the submission error alert")

	// MARK: - Features survey
	static let featuresChoicesButton = NSLocalizedString("feedback.features.choices.button", tableName: "Feedback", bundle: .module, value: "Next", comment: "Features survey: choices-step CTA button")
	static let featuresNotesFieldLabel = NSLocalizedString("feedback.features.notes.fieldLabel", tableName: "Feedback", bundle: .module, value: "Your feedback", comment: "Features survey: label above the notes text editor")
	static let featuresNotesButton = NSLocalizedString("feedback.features.notes.button", tableName: "Feedback", bundle: .module, value: "Send", comment: "Features survey: notes-step send button")
	static let featuresConfirmationButton = NSLocalizedString("feedback.features.confirmation.button", tableName: "Feedback", bundle: .module, value: "Close", comment: "Features survey: confirmation-step close button")
}
#endif
