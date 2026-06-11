#if os(iOS)
import Foundation

@available(iOS 17, *)
public struct UserFeedback: Sendable {
	public let email: String
	public let countryCode: String
	public let phoneNumber: String
	public let feedback: String
    public let choices: [String]

	public init(
		email: String,
		countryCode: String,
		phoneNumber: String,
		feedback: String,
        choices: [String] = []) {
		self.email = email
		self.countryCode = countryCode
		self.phoneNumber = phoneNumber
		self.feedback = feedback
        self.choices = choices
	}
}

@available(iOS 17, *)
public struct UserForm: Sendable {
    public let question: String
    public let feedback: String
    public let selectedChoices: [String]

    public init(
        question: String,
        feedback: String,
        selectedChoices: [String] = []) {
        self.question = question
        self.feedback = feedback
        self.selectedChoices = selectedChoices
    }
}
#endif
