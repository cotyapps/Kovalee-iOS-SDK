import Foundation
import KovaleeFramework
import KovaleeSDK

#if canImport(FirebaseCore)
    import FirebaseCore
#endif
#if canImport(FirebaseRemoteConfig)
    import FirebaseRemoteConfig
#endif
#if canImport(FirebaseAnalytics)
    import FirebaseAnalytics
#endif

actor FirebaseWrapperImpl: RemoteConfigurationManager, Manager {
    // Concurrent callers (e.g. abTestValue() racing with fetchCurrentOffering(),
    // which itself calls abTestValue() internally) would otherwise issue overlapping
    // RemoteConfig.fetchAndActivate() requests; Firebase cancels the in-flight one
    // and the losing call resolves with nil. We coalesce overlapping fetches into a
    // single shared Task so concurrent callers all observe the same outcome.
    private var inFlightFetch: Task<Void, Never>?

    init(keys: KovaleeKeys.Firebase) {
        if !keys.configuredInApp {
            #if canImport(FirebaseCore)
                FirebaseApp.configure()
            #endif
        }
    }

    nonisolated func setFetchTimeout(_ timeout: Double) {
        #if canImport(FirebaseRemoteConfig)
            RemoteConfig.remoteConfig().configSettings.fetchTimeout = timeout
        #endif
    }

    nonisolated func setDataCollectionEnabled(_ enabled: Bool) {
        #if canImport(FirebaseAnalytics)
            Analytics.setAnalyticsCollectionEnabled(enabled)
        #endif
    }

    nonisolated func setDefaultValues(_ values: [String: Any]) {
        #if canImport(FirebaseRemoteConfig)
            RemoteConfig.remoteConfig().setDefaults(values as? [String: NSObject])
        #endif
    }

    func fetchAndActivateRemoteConfig() async {
        #if canImport(FirebaseRemoteConfig)
            if let inFlightFetch {
                await inFlightFetch.value
                return
            }
            let task = Task { await Self.performFetchAndActivate() }
            inFlightFetch = task
            await task.value
            inFlightFetch = nil
        #endif
    }

    #if canImport(FirebaseRemoteConfig)
    private static func performFetchAndActivate() async {
        do {
            let remoteConfig = RemoteConfig.remoteConfig()
            try await remoteConfig.ensureInitialized()

            let activated = try await remoteConfig.fetchAndActivate()
            KLogger.debug("🛰️ Remote config activated: \(activated)")
            // Note: `.error` can be returned when the most recently fetched config
            // is already activated by the host app (see firebase-ios-sdk#3586). In
            // that case the values remain readable via `configValue(forKey:)`, so
            // we don't treat this status as fatal.

            let keys = remoteConfig.allKeys(from: RemoteConfigSource.remote)
            KLogger.debug("🛰️ Found remote config keys: [\(keys.joined(separator: ","))]")
        } catch {
            KLogger.error("❌ Got an error fetching remote values \(error)")
        }
    }
    #endif

    func value(forKey key: String) async throws -> Data {
        #if canImport(FirebaseRemoteConfig)
            await fetchAndActivateRemoteConfig()
            KLogger.debug("🛰️ initialization complete")

            return RemoteConfig.remoteConfig().configValue(forKey: key).dataValue
        #else
            return Data()
        #endif
    }
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

    #if canImport(FirebaseRemoteConfig)
        init(config: FirebaseRemoteConfig.RemoteConfigValue) {
            value = String(data: config.dataValue, encoding: .utf8)
            dataValue = config.dataValue
        }
    #endif
}

extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
}
