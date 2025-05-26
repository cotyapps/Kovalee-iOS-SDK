import Foundation
import KovaleeFramework
import KovaleeSDK
import PostHog

struct PosthogWrapperImpl: RemoteConfigurationManager, Manager {
    init(keys: KovaleeKeys.Posthog) {
        PostHogSDK.shared.setup(
            PostHogConfig(apiKey: keys.apiKey, host: keys.host)
        )
    }

    func fetchAndActivateRemoteConfig() async {
        await withCheckedContinuation { continuation in
            PostHogSDK.shared.reloadFeatureFlags {
                continuation.resume()
            }
        }
    }

    func value(forKey key: String) async throws -> Data {
        await fetchAndActivateRemoteConfig()
        KLogger.debug("🛰️ initialization complete")

        guard
            let value = PostHogSDK.shared.getFeatureFlag(key) as? String,
            let dataValue = value.data(using: .utf8)
        else {
            throw KovaleeError.remoteValueFetchError
        }

        return dataValue
    }
}
