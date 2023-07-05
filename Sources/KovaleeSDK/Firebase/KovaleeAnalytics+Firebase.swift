import Foundation
import KovaleeFramework

// MARK: Firebase
extension Kovalee {
    /// Retrieve Firebase ``RemoteConfigValue`` for a specific key
    ///
    /// - Parameters:
    ///    - key: string key of the remote value that the user is trying to load
    /// - Returns: retrieve the requested ``RemoteConfigValue`` if found
    /// - Throws: throws an error of type ``KovaleeError/remoteValueAlreadyUsedForABTest`` if they key is used for an AB Test experiment
    public static func remoteValue(forKey key: String) async throws -> RemoteConfigValue? {
		guard let data = try await Self.shared.kovaleeManager?.remoteValue(forKey: key) else {
			return nil
		}

		return RemoteConfigValue(data: data)
    }
    
    /// Set Default values in the Firebase RemoteConfig
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
    public static func abTestValue(forKey key: String) async -> RemoteConfigValue? {
		guard let data = await Self.shared.kovaleeManager?.abTestValue(forKey: key) else {
			return nil
		}

        return RemoteConfigValue(data: data)
    }
}
