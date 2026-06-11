#if os(iOS)
import FirebaseFunctions
import OSLog

@available(iOS 17, *)
public struct UserFeedbackService: Sendable {
	
	private let callFunction: @Sendable (String, [String: Any]) async throws -> Any

	/// - Parameter callFunction: Override the callable transport (e.g. for tests or previews); production leaves this `nil`.
	///
	/// The `writeToSheet` / `sendForm` callables resolve on the default Firebase app, matching the
	/// region the rest of the app's Firebase is configured for.
	public init(
		callFunction: (@Sendable (String, [String: Any]) async throws -> Any)? = nil
	) {
		self.callFunction = callFunction ?? { functionName, data in
			let result = try await Functions.functions().httpsCallable(functionName).call(data)
			return result.data
		}
	}
	
	public func sendFeedback(
		userFeedback feedback: UserFeedback,
		metadata: FeedbackMetadata
	) async throws {
		_ = try await callFunction("writeToSheet", [
			"email": feedback.email,
			"countryCode": feedback.countryCode,
			"phoneNumber": feedback.phoneNumber,
			"message": feedback.feedback,
			"osVersion": metadata.osVersion,
			"appVersion": metadata.appVersion,
			"rcUserId": metadata.rcUserId,
			"amplitudeUserId": metadata.amplitudeUserId,
			"subscriptionStatus": metadata.subscriptionStatus
		])
		Logger.userFeedback.debug("Send Feedback - Success")
	}

    public func sendForm(
        form: UserForm,
        metadata: FeedbackMetadata
    ) async throws {
        _ = try await callFunction("sendForm", [
            "question": form.question,
            "selectedChoices": form.selectedChoices,
            "message": form.feedback,
            "osVersion": metadata.osVersion,
            "appVersion": metadata.appVersion,
            "rcUserId": metadata.rcUserId,
            "amplitudeUserId": metadata.amplitudeUserId,
            "subscriptionStatus": metadata.subscriptionStatus
        ])
        Logger.userFeedback.debug("Send Form - Success")
    }
}

@available(iOS 17, *)
extension Logger {
	static let userFeedback = Logger(subsystem: "com.kovalee.userfeedback", category: "UserFeedback")
}
#endif
