import Foundation
import KovaleeFramework

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
    internal static func initialize(configuration: Configuration, storage: Storage) {
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
            self.initializedManager = .init(configuration: .preview, storage: .userDefaults())
            return self.initializedManager!
        } else {
            let errorMessage = "Please call KovaleeManager.initialize(...) before accessing the shared instance."
            Logger.error(errorMessage)
            fatalError(errorMessage)
        }
    }

	private init(configuration: Configuration, storage: Storage) {
		self.configuration = configuration
		
		Logger.logLevel = configuration.logLevel
		
		do {
			let keys = try Reader.kovaleeKeysReader.load(configuration.keysFileUrl)
			
			// avoid initializing third party tools if running UnitTests
			if !ProcessInfo.isRunningTests {
				let adjustWrapper = self.createAdjustWrapper(withConfiguration: configuration, andKey: keys.adjust)
				let amplitudeWrapper = self.createAmplitudeWrapper(withConfiguration: configuration, andKeys: keys.amplitude)
				let revenueCatWrapper = self.createRevenueCatWrapper(withKeys: keys.revenueCat)
				let firebaseWrapper = self.createFirebaseWrapper(withKeys: keys.firebase)
				let applovinWrapper = self.createApplovinWrapper(withKeys: keys.applovin)
				
				self.kovaleeManager = KovaleeManager.init(
					keys: keys,
					adjustWrapper: adjustWrapper,
					amplitudeWrapper: amplitudeWrapper,
					revenueCatWrapper: revenueCatWrapper,
					firebaseWrapper: firebaseWrapper,
					applovinWrapper: applovinWrapper
				)
			}

			self.kovaleeManager?.setDefaultUserId()
			self.kovaleeManager?.sendAppOpenEvent()
		} catch {
			Logger.error("We couldn't find the file at \(configuration.keysFileUrl?.absoluteString ?? "")")
			Logger.error("Please add the file KovaleeKeys.json to your project")
			fatalError(error.localizedDescription)
		}
	}

    private static var initializedManager: Kovalee?
	internal var kovaleeManager: KovaleeManager?
	
	private var configuration: Configuration
}


extension Kovalee {
	internal func createAdjustWrapper(withConfiguration configuration: Configuration, andKey key: String) -> AdjustWrapper {
		AdjustWrapperImpl(
			configuration: AdjustConfiguration(
				environment: configuration.environment.rawValue,
				token: key
			),
			attributionAdidCallback: {
				self.kovaleeManager?.attributionCallback(withAdid: $0)
			}
		)
	}
	
	internal func createAmplitudeWrapper(withConfiguration configuration: Configuration, andKeys keys: KovaleeKeys.Amplitude) -> AmplitudeWrapper {
		if configuration.environment == .sandbox && keys.devSDKId == nil {
			Logger.error("Configured Sandbox environment but Amplitude Dev key hasn't been provided")
		}
		return AmplitudeWrapperImpl(
			withKey: configuration.environment == .production ? keys.prodSDKId : (keys.devSDKId ?? "")
		)
	}
	
	internal func createFirebaseWrapper(withKeys keys: KovaleeKeys.Firebase?) -> FirebaseWrapper? {
		guard let keys else {
			return nil
		}
		return FirebaseWrapperImpl(keys: keys)
	}

	internal func createRevenueCatWrapper(withKeys keys: KovaleeKeys.RevenueCat?) -> RevenueCatWrapper? {
		guard let keys else {
			return nil
		}
		return RevenueCatWrapperImpl(withKeys: keys)
	}
	
	internal func createApplovinWrapper(withKeys keys: KovaleeKeys.Applovin?) -> ApplovinWrapper? {
		guard let keys else {
			return nil
		}
		return ApplovinWrapperImpl.init(withKey: keys)
	}
}
