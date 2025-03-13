import AppTrackingTransparency
import Foundation
import KovaleeFramework
import KovaleeSDK

extension AttributionManagerCreator: Creator {
    public func createImplementation(
        withConfiguration configuration: Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager {
        guard let key = keys.adjust else {
            fatalError("No configuration Key for Adjust found in the Keys file")
        }

        return AdjustWrapperImpl(
            configuration: AdjustConfiguration(
                environment: configuration.environment.rawValue,
                token: key
            ),
            attributionAdidCallback: {
                self.attributionAdidCallback($0)
            }
        )
    }
}

// MARK: Adjust

public extension Kovalee {
    /// Prompt the user with tracking authorization alert view
    ///
    /// This method uses a trailing closure as return value.
    /// To get the return value using Swift async/awat, use: ``promptTrackingAuthorization()``
    ///
    /// - Returns:a completion block returning the `ATTrackingManager.AuthorizationStatus` based on the user response
    ///  based on the user response
    static func promptTrackingAuthorization(
        completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void
    ) {
        shared.kovaleeManager?.promptTrackingAuthorization(completion: completion)
    }

    /// Prompt the user with tracking authorization alert view
    ///
    /// This method uses Swift async/await.
    /// To get the return value in a trailing closure, use: ``promptTrackingAuthorization(completion:)``
    ///
    /// - Returns:the `ATTrackingManager.AuthorizationStatus` based on the user response
    @discardableResult
    static func promptTrackingAuthorization() async -> ATTrackingManager.AuthorizationStatus {
        await withUnsafeContinuation { continuation in
            Self.shared.kovaleeManager?.promptTrackingAuthorization { userState in
                continuation.resume(returning: userState)
            }
        }
    }

    /// Retrieve the Adjust identifier value
    ///
    /// - Returns: the Adjust identifier value
    static func getAttributionAdid() async -> String? {
        await shared.kovaleeManager?.getAttributionAdid()
    }
}
