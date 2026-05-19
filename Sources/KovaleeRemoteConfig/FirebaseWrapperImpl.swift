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

    // Caches the launch override after the first read so repeat calls to
    // value(forKey:) within the same launch return the same value, even after
    // AbTestOverride.consume() has cleared the persisted entry.
    private var cachedAbTestOverride: String?

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
        // Launch-override interception: when the debug panel has queued a one-shot
        // override for the AB test key, return it here instead of fetching from
        // RemoteConfig. The binary stores whatever this method returns as the
        // "fetched" value, so the override persists across launches without
        // racing the binary's own setAbTestValue gate.
        if key == Kovalee.abTestKey {
            if let cached = cachedAbTestOverride {
                KLogger.debug("🧪 [value(forKey:)] returning cached AB test override: \(cached)")
                return Data(cached.utf8)
            }
            if let override = AbTestOverride.consume() {
                cachedAbTestOverride = override
                KLogger.debug("🧪 [value(forKey:)] consuming AB test override: \(override)")
                return Data(override.utf8)
            }
        }

        #if canImport(FirebaseRemoteConfig)
            KLogger.debug("🛰️ [value(forKey:)] fetching \(key) from Firebase")
            await fetchAndActivateRemoteConfig()
            KLogger.debug("🛰️ initialization complete")

            let data = RemoteConfig.remoteConfig().configValue(forKey: key).dataValue
            let asString = String(data: data, encoding: .utf8) ?? "<binary>"
            KLogger.debug("🛰️ [value(forKey:)] Firebase returned \(key) = \(asString)")
            return data
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
