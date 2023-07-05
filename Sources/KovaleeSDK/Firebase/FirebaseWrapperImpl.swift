import Foundation
import KovaleeFramework
import FirebaseCore
import FirebaseAnalytics
import FirebaseRemoteConfig

struct FirebaseWrapperImpl: FirebaseWrapper {
	init(keys: KovaleeKeys.Firebase) {
        let options = FirebaseOptions(
			googleAppID: keys.appId,
			gcmSenderID: keys.senderId
        )
		options.apiKey = keys.apiKey
		options.projectID = keys.projectId

        FirebaseApp.configure(options: options)
        Analytics.setAnalyticsCollectionEnabled(true)

        self.remoteConfig = RemoteConfig.remoteConfig()
    }

    func setDefaultValues(_ values: [String: Any]) {
        self.remoteConfig.setDefaults(values as? [String: NSObject])
    }

    private func fetchAndActivateRemoteConfig() async throws {
        do {
            try await self.remoteConfig.ensureInitialized()
            
            let activated = try await remoteConfig.fetchAndActivate()
            Logger.debug("🛰️ Remote config activated: \(activated)")
            if activated == RemoteConfigFetchAndActivateStatus.error {
                throw KovaleeError.remoteValueFetchError
            }

            let keys = remoteConfig.allKeys(from: RemoteConfigSource.remote)
            Logger.debug("🛰️ Found remote config keys: [\(keys.joined(separator: ","))]")
        } catch {
            Logger.error("❌ Got an error fetching remote values \(error)")
        }
    }

    func value(forKey key: String) async throws -> Data {
        try await fetchAndActivateRemoteConfig()
        Logger.debug("🛰️ initialization complete")

		return remoteConfig.configValue(forKey: key).dataValue
    }

    private let remoteConfig: RemoteConfig
}

/// This class provides a wrapper for Remote Config parameter values, with methods to get parameter
/// values as different data types.
public class RemoteConfigValue {
    /// Gets the value as a string.
    public var value: String?

    /// Gets the value as a Data object.
    public var dataValue: Data

    /// Gets the value as a number value.
    public var numberValue: Double? {
        guard let value else {
            return nil
        }
        return Double(value)
    }

    /// Gets the value as a boolean.
    public var boolValue: Bool? {
        guard let value else {
            return nil
        }
        
        return value.boolValue
    }

    init(data: Data) {
        self.value = String(data: data, encoding: .utf8)
        self.dataValue = data
    }

    init(config: FirebaseRemoteConfig.RemoteConfigValue) {
        self.value = String(data: config.dataValue, encoding: .utf8)
        self.dataValue = config.dataValue
    }
}

extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
}
