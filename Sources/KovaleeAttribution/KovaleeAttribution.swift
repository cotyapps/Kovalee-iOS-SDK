import Foundation
import AppTrackingTransparency
import KovaleeFramework
import KovaleeSDK

// MARK: Adjust
extension Kovalee {
	private func createAdjustWrapper(withConfiguration configuration: Configuration, andKey key: String) -> AdjustWrapper {
		AdjustWrapperImpl(
			configuration: AdjustConfiguration(
				environment: configuration.environment.rawValue,
				token: key
			),
			attributionAdidCallback: {
				self.kovaleeManager?.attributionCallback(withAdid: $0)
			}
		)
	}

	/// Prompt the user with tracking authorization alert view
	///
	/// This method uses a trailing closure as return value.
	/// To get the return value using Swift async/awat, use: ``promptTrackingAuthorization()``
	///
	/// - Returns:a completion block returning the `ATTrackingManager.AuthorizationStatus` based on the user response
	///  based on the user response
	public static func promptTrackingAuthorization(
		completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void
	) {
		Self.shared.kovaleeManager?.promptTrackingAuthorization(completion: completion)
	}

	/// Prompt the user with tracking authorization alert view
	///
	/// This method uses Swift async/await.
	/// To get the return value in a trailing closure, use: ``promptTrackingAuthorization(completion:)``
	///
	/// - Returns:the `ATTrackingManager.AuthorizationStatus` based on the user response
	@discardableResult
	public static func promptTrackingAuthorization() async -> ATTrackingManager.AuthorizationStatus {
		await withCheckedContinuation { continuation in
			Self.shared.kovaleeManager?.promptTrackingAuthorization { userState in
				continuation.resume(returning: userState)
			}
		}
	}
}
