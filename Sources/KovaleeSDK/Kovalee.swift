import Foundation
import KovaleeFramework

public let SDK_VERSION = "2.0.3"

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
        getInitializedManager() != nil
    }

    /// Initiialize Kovalee with specific configuration
    /// - Parameters:
    ///   - configuration: the configuration to be used by Kovalee
    public static func initialize(configuration: Configuration) {
        setInitializedManager(.init(configuration: configuration, storage: Storage()))
    }

    /// used for testing purpose mainly
    static func initialize(configuration: Configuration, storage: Storage) {
        setInitializedManager(.init(configuration: configuration, storage: storage))
    }

    /// terminate current Kovalee instance
    public static func terminate() {
        setInitializedManager(nil)
    }

    /// Kovalee shared instance
    public static var shared: Kovalee {
        if let manager = getInitializedManager() {
            return manager
        } else if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            // SwiftUI Previews, this is not a real launch of the app, therefore mock data is used
            let newManager = self.init(configuration: .preview, storage: Storage())
            setInitializedManager(newManager)
            return newManager
        } else {
            let errorMessage = "Please call Kovalee.initialize(...) before accessing the shared instance."
            KLogger.error(errorMessage)
            fatalError(errorMessage)
        }
    }

    private init(configuration: Configuration, storage _: Storage) {
        self.configuration = configuration

        KLogger.logLevel = configuration.logLevel

        do {
            keys = try Reader.kovaleeKeysReader.load(configuration.keysFileUrl)

            guard let eventTracker = EventsTrackerManagerCreator().createImplementation(
                withConfiguration: configuration,
                andKeys: keys
            ) as? EventTrackerManager else {
                fatalError("Failed to create EventTrackerManager")
            }

            kovaleeManager = KovaleeManager(
                keys: keys,
                sdkVersion: SDK_VERSION,
                eventTrackerManager: eventTracker,
                alreadyIntegrated: configuration.alreadyIntegrated
            )

            setupCapabilities()

            kovaleeManager?.setDefaultUserId()
            kovaleeManager?.sendAppOpenEvent()
        } catch {
            KLogger.error("We couldn't find the file at \(configuration.keysFileUrl?.absoluteString ?? "")")
            KLogger.error("Please add the file KovaleeKeys.json to your project")
            fatalError(error.localizedDescription)
        }
    }

    public var keys: KovaleeKeys
    public var kovaleeManager: KovaleeManager?
    public var configuration: Configuration
}

// MARK: - Private Singleton Implementation

private extension Kovalee {
    // A lock for thread-safe access to the initializedManager
    static let lock = NSLock()

    // Thread-safe storage for the singleton instance
    // Mark as nonisolated(unsafe) to indicate we're handling thread safety ourselves
    nonisolated(unsafe) static var _initializedManager: Kovalee?

    static func getInitializedManager() -> Kovalee? {
        lock.lock()
        defer { lock.unlock() }
        return _initializedManager
    }

    static func setInitializedManager(_ manager: Kovalee?) {
        lock.lock()
        defer { lock.unlock() }
        _initializedManager = manager
    }
}

// MARK: - Capabilities Setup

extension Kovalee {
    private func setupCapabilities() {
        for item in Capabilities.allCases {
            switch item {
            case .attribution:
                let creator = AttributionManagerCreator { adid in
                    Kovalee.performAttributionCallback(with: adid)
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

            case .survey:
                guard keys.survicate?.sdkId != nil else {
                    continue
                }
                let creator = SurveyManagerCreator()
                if let surveyManager = (creator as? Creator)?.createImplementation(
                    withConfiguration: configuration,
                    andKeys: keys
                ) as? SurveyManager {
                    kovaleeManager?.setupSurveyManager(surveyManager: surveyManager)
                }

            case .eventsTracking: ()
            }
        }
    }
}

extension Kovalee {
    // Accesses the shared instance without capturing self in the closure.
    static func performAttributionCallback(with adid: String?) {
        shared.kovaleeManager?.attributionCallback(withAdid: adid)
    }
}

enum Capabilities: CaseIterable {
    case eventsTracking
    case attribution
    case purchases
    case remoteConfiguration
    case survey
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
    public var attributionAdidCallback: @Sendable (String?) -> Void
}

public struct PurchaseManagerCreator {}
public struct RemoteConfigManagerCreator {}
public struct SurveyManagerCreator {}
