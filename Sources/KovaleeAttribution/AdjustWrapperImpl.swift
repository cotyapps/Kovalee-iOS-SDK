import AdjustSdk
import AdSupport
import AppTrackingTransparency
import Foundation
import KovaleeFramework
import KovaleeSDK

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

public extension AdjustConfiguration {
    static var test: Self {
        Self(environment: "test", token: "")
    }
}

final class AdjustWrapperImpl: NSObject, AttributionManager, Manager {
    init(
        configuration: AdjustConfiguration,
        attributionAdidCallback: @escaping @Sendable (String?) -> Void
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
        adjustConfig?.attConsentWaitingInterval = 3
        adjustConfig?.delegate = self

        Adjust.initSdk(adjustConfig)
    }

    func setDataCollectionEnabled(_ enabled: Bool) {
        guard let value = ADJThirdPartySharing(isEnabled: enabled ? 1 : 0) else {
            return
        }
        Adjust.trackThirdPartySharing(value)
    }

    func getAttributionAdid() async -> String? {
        await Adjust.adid()
    }

    func promptTrackingAuthorization(completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void) {
        Adjust.requestAppTrackingAuthorization { _ in
            completion(ATTrackingManager.trackingAuthorizationStatus)
        }
    }

    func sendConversionValue(value: Int, coarseValue: String?, completion: @escaping (Error?) -> Void) {
        Adjust.updateSkanConversionValue(value, coarseValue: coarseValue, lockWindow: false) { error in
            completion(error)
        }
    }

    let attributionAdidCallback: @Sendable (String?) -> Void
    let configuration: AdjustConfiguration
}

extension AdjustWrapperImpl: AdjustDelegate {
    func adjustAttributionChanged(_: ADJAttribution?) {
//        self.attributionAdidCallback(attribution?.adid)
    }

    func adjustConversionValueUpdated(_ fineValue: NSNumber?, coarseValue _: String?, lockWindow _: NSNumber?) {
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
            .verbose
        case .debug:
            .debug
        case .info:
            .info
        case .warn:
            .warn
        case .error:
            .error
        @unknown default:
            fatalError()
        }
    }
}
