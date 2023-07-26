import AdSupport
import AppTrackingTransparency
import Foundation
import KovaleeFramework
import Adjust

extension AdjustConfiguration.Environment {
	var adjustEnvironment: String {
		switch self {
		case .production:
			return ADJEnvironmentProduction
		default:
			return ADJEnvironmentSandbox
		}
	}
}

extension AdjustConfiguration {
    public static var test: Self {
        Self.init(environment: "test", token: "")
    }
}

class AdjustWrapperImpl: NSObject, AttributionManager {
    init(
        configuration: AdjustConfiguration,
        attributionAdidCallback: @escaping (String?) -> Void
    ) {
		KLogger.debug("initializing Adjust")

        self.attributionAdidCallback = attributionAdidCallback
		self.configuration = configuration
        super.init()

        let adjustConfig = ADJConfig(
            appToken: configuration.token,
            environment: configuration.environment.adjustEnvironment
        )
        adjustConfig?.logLevel = KLogger.logLevel.adjustLogLevel()
        adjustConfig?.delayStart = 2.5
        adjustConfig?.delegate = self

        Adjust.appDidLaunch(adjustConfig)
    }

    func getAttributionAdid() -> String? {
		Adjust.attribution()?.adid
    }

    func promptTrackingAuthorization(completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void) {
        Adjust.requestTrackingAuthorization { _ in
            completion(ATTrackingManager.trackingAuthorizationStatus)
        }
    }

    func sendConversionValue_SKA3(value: Int) {
        Adjust.updateConversionValue(value)
    }

	func sendConversionValue_SKA4(value: Int, coarseValue: String, completion: @escaping (Error?) -> Void) {
        Adjust.updatePostbackConversionValue(value, coarseValue: coarseValue, lockWindow: false) { error in
			completion(error)
        }
    }

    var attributionAdidCallback: (String?) -> Void
	var configuration: AdjustConfiguration
}

extension AdjustWrapperImpl: AdjustDelegate {
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
		self.attributionAdidCallback(attribution?.adid)
    }

	func adjustConversionValueUpdated(_ fineValue: NSNumber?, coarseValue: String?, lockWindow: NSNumber?) {
		KLogger.debug("Successfully Updated Conversion Value: \(String(describing: fineValue))")
	}
}

extension AttributionManager {
    static var test: AttributionManager {
        AdjustWrapperImpl(
            configuration: .test,
			attributionAdidCallback: { _ in }
        )
    }
}

extension LogLevel {
    func adjustLogLevel() -> ADJLogLevel {
        switch self {
        case .verbose:
            return ADJLogLevelVerbose
        case .debug:
            return ADJLogLevelDebug
        case .info:
            return ADJLogLevelInfo
        case .warn:
            return ADJLogLevelWarn
        case .error:
            return ADJLogLevelError
		@unknown default:
			fatalError()
		}
    }
}
