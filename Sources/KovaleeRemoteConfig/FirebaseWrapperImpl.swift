import FirebaseAnalytics
import FirebaseCore
@preconcurrency import FirebaseRemoteConfig
import Foundation
import KovaleeFramework
import KovaleeSDK

struct FirebaseWrapperImpl: RemoteConfigurationManager, Manager {
    init(keys: KovaleeKeys.Firebase) {
        if !keys.configuredInApp {
            FirebaseApp.configure()
        }

        remoteConfig = RemoteConfig.remoteConfig()
    }

    func setFetchTimeout(_ timeout: Double) {
        remoteConfig.configSettings.fetchTimeout = timeout
    }

    func setDataCollectionEnabled(_ enabled: Bool) {
        Analytics.setAnalyticsCollectionEnabled(enabled)
    }

    func setDefaultValues(_ values: [String: Any]) {
        remoteConfig.setDefaults(values as? [String: NSObject])
    }

    func fetchAndActivateRemoteConfig() async {
        do {
            try await remoteConfig.ensureInitialized()

            let activated = try await remoteConfig.fetchAndActivate()
            KLogger.debug("🛰️ Remote config activated: \(activated)")
            if activated == RemoteConfigFetchAndActivateStatus.error {
                throw KovaleeError.remoteValueFetchError
            }

            let keys = remoteConfig.allKeys(from: RemoteConfigSource.remote)
            KLogger.debug("🛰️ Found remote config keys: [\(keys.joined(separator: ","))]")
        } catch {
            KLogger.error("❌ Got an error fetching remote values \(error)")
        }
    }

    func value(forKey key: String) async throws -> Data {
        await fetchAndActivateRemoteConfig()
        KLogger.debug("🛰️ initialization complete")

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
        value = String(data: data, encoding: .utf8)
        dataValue = data
    }

    init(config: FirebaseRemoteConfig.RemoteConfigValue) {
        value = String(data: config.dataValue, encoding: .utf8)
        dataValue = config.dataValue
    }
}

extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
}
