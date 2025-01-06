import Foundation
import KovaleeFramework
import KovaleeSDK

extension RemoteConfigManagerCreator: Creator {
    public func createImplementation(
        withConfiguration configuration: Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager {
        guard let key = keys.firebase else {
            fatalError("No configuration Key for Firebase found in the Keys file")
        }

        return FirebaseWrapperImpl(keys: key)
    }
}

// MARK: Firebase
extension Kovalee {
    public static let abTestKey = "ab_test_version"

    /// Set the fetch timeout for ``Firebase/RemoteConfig``
    ///
    /// - Parameters:
    ///    - timeout: value of the timeout in seconds
    public static func setFetchTimeout(_ timeout: Double) {
        Self.shared.kovaleeManager?.setFetchTimeout(timeout)
    }

    /// Retrieves asynchronously Firebase ``RemoteConfigValue`` for a specific key
    ///
    /// - Parameters:
    ///    - key: string key of the remote value that the user is trying to load
    /// - Returns: retrieve the requested ``RemoteConfigValue`` if found
    public static func remoteValue(forKey key: String) async -> RemoteConfigValue? {
        guard key != abTestKey else {
            KLogger.error("❌ ab_test_version is a private key and can't be used for remote config")
            return nil
        }

        guard let data = try? await Self.shared.kovaleeManager?.remoteValue(forKey: key) else {
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
    public static func remoteValue(
        forKey key: String,
        withCompletion completion: @escaping (RemoteConfigValue?) -> Void
    ) {
        Task {
            completion(await Self.remoteValue(forKey: key))
        }
    }

    /// Set Default values in the Firebase RemoteConfig.
    ///    This method shold be only used for Remote Values NOT AB tests
    ///
    /// - Parameters:
    ///    - values: a dictionary of values to be stored
    public static func setDefaultValues(_ values: [String: Any]) {
        Self.shared.kovaleeManager?.setDefaultValues(values)
    }

    /// Retrieve the value associated with an AB testing experiment
    ///
    /// - Parameters:
    ///    - key: string key of the remote value that the user is trying to load
    /// - Returns: retrieve the requested ``RemoteConfigValue`` if found
    @available(*, deprecated, renamed: "abTestValue")
    public static func abTestValue(forKey key: String) async -> String? {
        await Self.abTestValue()
    }

    /// Retrieve the value associated with an AB testing experiment
    ///
    /// - Returns: retrieve the requested ``RemoteConfigValue`` if found
    public static func abTestValue() async -> String? {
        guard let value = await Self.shared.kovaleeManager?.abTestValue(forKey: Self.abTestKey) else {
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
    public static func abTestValue(withCompletion completion: @escaping (String?) -> Void) {
        Task {
            completion(await Self.abTestValue())
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
    public static func setAbTestValue(_ value: String) {
        Self.shared.kovaleeManager?.setAbTestValue(value)
    }

    /// Retrieve the local value associated with an AB testing experiment.
    ///
    /// This function will only return a value if one of the following 2 conditions is met:
    /// - the remote ab test value has been fetched during a previous run of the app
    /// - if the ab test value has been set manually using ``setAbTestValue(_:)``
    /// If none of the two conditions is met, the function will return nil
    ///
    /// - Returns: retrieve the requested ab test value if found
    public static func localAbTestValue() -> String? {
        Self.shared.kovaleeManager?.localABTestValue()
    }
}
