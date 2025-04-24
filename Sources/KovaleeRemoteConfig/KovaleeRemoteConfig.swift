import Foundation
import KovaleeFramework
import KovaleeSDK

extension RemoteConfigManagerCreator: Creator {
    public func createImplementation(
        withConfiguration _: Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager {
        guard let key = keys.firebase else {
            fatalError("No configuration Key for Firebase found in the Keys file")
        }

        return FirebaseWrapperImpl(keys: key)
    }
}

// MARK: Firebase

public extension Kovalee {
    static let abTestKey = "ab_test_version"

    /// Set the fetch timeout for ``Firebase/RemoteConfig``
    ///
    /// - Parameters:
    ///    - timeout: value of the timeout in seconds
    static func setFetchTimeout(_ timeout: Double) {
        shared.kovaleeManager?.setFetchTimeout(timeout)
    }

    /// Retrieves asynchronously Firebase ``RemoteConfigValue`` for a specific key
    ///
    /// - Parameters:
    ///    - key: string key of the remote value that the user is trying to load
    /// - Returns: retrieve the requested ``RemoteConfigValue`` if found
    static func remoteValue(forKey key: String) async -> RemoteConfigValue? {
        guard key != abTestKey else {
            KLogger.error("❌ ab_test_version is a private key and can't be used for remote config")
            return nil
        }

        guard let data = try? await shared.kovaleeManager?.remoteValue(forKey: key) else {
            return nil
        }

        return RemoteConfigValue(data: data)
    }

    /// Retrieves asynchronously Firebase ``RemoteConfigValue`` for a specific key
    ///
    /// - Parameters:
    ///    - key: string key of the remote value that the user is trying to load
    ///    - completion: A closure that is called with the result of the fetch operation.
    ///        This closure has no return value and takes the following parameter:
    ///        - value: The requested value as a ``RemoteConfigValue``. If no value is found, `nil` is provided.
    static func remoteValue(
        forKey key: String,
        withCompletion completion: @escaping @Sendable (RemoteConfigValue?) -> Void
    ) {
        // Create a local copy of the key to avoid capturing self
        let keyValue = key
        Task { @Sendable in
            let result = await Self.remoteValue(forKey: keyValue)
            completion(result)
        }
    }

    /// Set Default values in the Firebase RemoteConfig.
    ///    This method shold be only used for Remote Values NOT AB tests
    ///
    /// - Parameters:
    ///    - values: a dictionary of values to be stored
    static func setDefaultValues(_ values: [String: Any]) {
        shared.kovaleeManager?.setDefaultValues(values)
    }

    /// Retrieve the value associated with an AB testing experiment
    ///
    /// - Returns: retrieve the requested ``RemoteConfigValue`` if found
    static func abTestValue() async -> String? {
        guard let value = await shared.kovaleeManager?.abTestValue(forKey: abTestKey) else {
            KLogger.error("❌ No AB test value found")
            return nil
        }

        return value
    }

    /// Retrieves the value associated with an AB testing experiment asynchronously.
    ///
    /// - Parameter completion: A closure that is called with the result of the fetch operation.
    ///   This closure has no return value and takes the following parameter:
    ///   - value: The retrieved AB test value as a `String?`. If no value is found, `nil` is provided.
    static func abTestValue(withCompletion completion: @escaping @Sendable (String?) -> Void) {
        Task { @Sendable in
            let result = await Self.abTestValue()
            completion(result)
        }
    }

    /// Set a default value for the AB test experiment
    ///
    ///    ATTENTION: this method will only succeed if no AB test value has been previously fetched.
    ///    Once the value has been set, it will be final. It won't be overridden, not even if subsequently fetched from remote.
    ///    The value set with this method will be the definitive AB test value for the current user.
    ///
    /// - Parameters:
    ///    - value: the value to be set to the AB Test experiment
    static func setAbTestValue(_ value: String) {
        // Create a local copy to avoid capturing self
        let valueToSet = value
        Task { @Sendable in
            Self.shared.kovaleeManager?.setAbTestValue(valueToSet)
        }
    }

    /// Retrieve the local value associated with an AB testing experiment.
    ///
    /// This function will only return a value if one of the following 2 conditions is met:
    /// - the remote ab test value has been fetched during a previous run of the app
    /// - if the ab test value has been set manually using ``setAbTestValue(_:)``
    /// If none of the two conditions is met, the function will return nil
    ///
    /// - Returns: retrieve the requested ab test value if found
    static func localAbTestValue() -> String? {
        shared.kovaleeManager?.localABTestValue()
    }
}
