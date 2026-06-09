#if os(iOS)
import FirebaseFunctions
import OSLog

@available(iOS 17, *)
public struct UserFeedbackService: Sendable {
	
	private let callFunction: @Sendable (String, [String: Any]) async throws -> Any

	/// - Parameters:
	///   - region: Cloud Functions region the `writeToSheet` / `sendForm` callables are deployed to.
	///     `nil` or a blank string uses Firebase's default (`us-central1`); set this when your callables
	///     live elsewhere (e.g. `"europe-west1"`), otherwise every submission fails with `NOT_FOUND`.
	///   - callFunction: Override the callable transport (e.g. for tests or previews); production leaves this `nil`.
	public init(
		region: String? = nil,
		callFunction: (@Sendable (String, [String: Any]) async throws -> Any)? = nil
	) {
		let normalizedRegion = region.flatMap { value -> String? in
			let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
			return trimmed.isEmpty ? nil : trimmed
		}
		self.callFunction = callFunction ?? { functionName, data in
			let functions = normalizedRegion.map { Functions.functions(region: $0) } ?? Functions.functions()
			let result = try await functions.httpsCallable(functionName).call(data)
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
