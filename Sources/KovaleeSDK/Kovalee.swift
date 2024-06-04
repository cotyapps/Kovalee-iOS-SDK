import Foundation
import KovaleeFramework

public let SDK_VERSION = "1.9.19"

/// A wrapper around all the third party tools used by Kovalee to gather information within the apps
///
/// You initialize Kovalee by providing a ``Configuration``.
/// Based on the configuration provided,
/// Kovalee loads an ``Configuration/Environment-swift.enum`` and specific ``LogLevel``.
///
/// ```swift
/// Kovalee.initialize(
///     configuration: Configuration(
///         environment: .production,
///         logLevel: .error
///     )
/// )
/// ```
public final class Kovalee {
    /// Checks if Kovalee has been initialized
    public static var isInitialized: Bool {
        initializedManager != nil
    }

    /// Initiialize Kovalee with specific configuration
    /// - Parameters:
    ///   - configuration: the configuration to be used by Kovalee
    public static func initialize(configuration: Configuration) {
        initializedManager = .init(configuration: configuration, storage: .userDefaults())
    }

    /// used for testing purpose mainly
    static func initialize(configuration: Configuration, storage: Storage) {
        initializedManager = .init(configuration: configuration, storage: storage)
    }

    /// terminate current Kovalee instance
    public static func terminate() {
        initializedManager = nil
    }

    /// Kovalee shared instance
    public static var shared: Kovalee {
        if let initializedManager {
            return initializedManager
        } else if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            // SwiftUI Previews, this is not a real launch of the app, therefore mock data is used
            initializedManager = .init(configuration: .preview, storage: .userDefaults())
            return initializedManager!
        } else {
            let errorMessage = "Please call KovaleeManager.initialize(...) before accessing the shared instance."
            KLogger.error(errorMessage)
            fatalError(errorMessage)
        }
    }

    private init(configuration: Configuration, storage _: Storage) {
        self.configuration = configuration

        KLogger.logLevel = configuration.logLevel

        do {
            keys = try Reader.kovaleeKeysReader.load(configuration.keysFileUrl)

            // avoid initializing third party tools if running UnitTests
            if !ProcessInfo.isRunningTests {
                let eventTracker = EventsTrackerManagerCreator().createImplementation(
                    withConfiguration: configuration,
                    andKeys: keys
                ) as! EventTrackerManager

                kovaleeManager = KovaleeManager(
                    keys: keys,
                    sdkVersion: SDK_VERSION,
                    eventTrackerManager: eventTracker
                )

                setupCapabilities()
            }

            kovaleeManager?.setDefaultUserId()
            kovaleeManager?.sendAppOpenEvent()
        } catch {
            KLogger.error("We couldn't find the file at \(configuration.keysFileUrl?.absoluteString ?? "")")
            KLogger.error("Please add the file KovaleeKeys.json to your project")
            fatalError(error.localizedDescription)
        }
    }

    private static var initializedManager: Kovalee?

    public var keys: KovaleeKeys
    public var kovaleeManager: KovaleeManager?
    public var configuration: Configuration
}

extension Kovalee {
    private func setupCapabilities() {
        for item in Capabilities.allCases {
            switch item {
            case .attribution:
                let creator = AttributionManagerCreator {
                    self.kovaleeManager?.attributionCallback(withAdid: $0)
                }
                if let attributionManager = (creator as? Creator)?.createImplementation(
                    withConfiguration: configuration,
                    andKeys: keys
                ) as? AttributionManager {
                    kovaleeManager?.setupAttributionManager(adjustWrapper: attributionManager)
                }

            case .purchases:
                let creator = PurchaseManagerCreator()
                if let purchaseManager = (creator as? Creator)?.createImplementation(
                    withConfiguration: configuration,
                    andKeys: keys
                ) as? PurchaseManager {
                    kovaleeManager?.setupPurchaseManager(purchaseManager: purchaseManager)
                }

            case .remoteConfiguration:
                let creator = RemoteConfigManagerCreator()
                if let remoteConfigManager = (creator as? Creator)?.createImplementation(
                    withConfiguration: configuration,
                    andKeys: keys
                ) as? RemoteConfigurationManager {
                    kovaleeManager?.setupRemoteConfigurationManager(remoteConfigManager: remoteConfigManager)
                }

            case .ads:
                let creator = AdsManagerCreator()
                if let adsManager = (creator as? Creator)?.createImplementation(
                    withConfiguration: configuration,
                    andKeys: keys
                ) as? AdsManager {
                    kovaleeManager?.setupAdsManager(adsManager: adsManager)
                }

            case .paywall:
                guard keys.superwall != nil else {
                    return
                }
                let creator = PaywallManagerCreator()
                if let paywallManager = (creator as? Creator)?.createImplementation(
                    withConfiguration: configuration,
                    andKeys: keys
                ) as? PaywallManager {
                    kovaleeManager?.setupPaywallManager(paywallManager: paywallManager)
                }
            case .eventsTracking: ()
            }
        }
    }
}

enum Capabilities: CaseIterable {
    case eventsTracking
    case attribution
    case purchases
    case remoteConfiguration
    case ads
    case paywall
}

public protocol Manager {}

public protocol Creator {
    func createImplementation(
        withConfiguration configuration: Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager
}

public struct EventsTrackerManagerCreator {}
public struct AttributionManagerCreator {
    public var attributionAdidCallback: (String?) -> Void
}

public struct PurchaseManagerCreator {}
public struct RemoteConfigManagerCreator {}
public struct AdsManagerCreator {}
public struct PaywallManagerCreator {}
