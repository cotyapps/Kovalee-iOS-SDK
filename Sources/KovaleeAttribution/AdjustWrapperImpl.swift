import Foundation
import KovaleeFramework
import KovaleeSDK


#if canImport(AppTrackingTransparency)
    import AppTrackingTransparency
#endif

#if canImport(AdjustSdk)
    import AdjustSdk
    import AdSupport

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

        func promptTrackingAuthorization(completion: @Sendable @escaping (ATTrackingManager.AuthorizationStatus) -> Void) {
            Adjust.requestAppTrackingAuthorization { _ in
                completion(ATTrackingManager.trackingAuthorizationStatus)
            }
        }

        func sendConversionValue(value: Int, coarseValue: String?, completion: @escaping (Error?) -> Void) {
            Adjust.updateSkanConversionValue(value, coarseValue: coarseValue, lockWindow: false) { error in
                completion(error)
            }
        }

        func setAttributionDelegate(_ delegate: KovaleeFramework.KovaleeAttributionDelegate) {
            self.delegate = delegate
        }

        let attributionAdidCallback: @Sendable (String?) -> Void
        let configuration: AdjustConfiguration

        private var delegate: KovaleeFramework.KovaleeAttributionDelegate?
    }

    extension AdjustWrapperImpl: @unchecked Sendable {}

    extension AdjustWrapperImpl: AdjustDelegate {
        func adjustSessionTrackingSucceeded(_ session: ADJSessionSuccess?) {
            attributionAdidCallback(session?.adid)
        }

        func adjustConversionValueUpdated(_ fineValue: NSNumber?, coarseValue _: String?, lockWindow _: NSNumber?) {
            KLogger.debug("Successfully Updated Conversion Value: \(String(describing: fineValue))")
        }

        func adjustDeferredDeeplinkReceived(_ deeplink: URL?) -> Bool {
            delegate?.adjustDeferredDeeplinkReceived(deeplink) ?? true
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

    extension KovaleeFramework.LogLevel {
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
#else
    final class AdjustWrapperImpl: NSObject, AttributionManager, Manager {
        init(
            configuration: AdjustConfiguration,
            attributionAdidCallback: @escaping @Sendable (String?) -> Void
        ) {
        }

        func getAttributionAdid() async -> String? {
            nil
        }
        
        #if canImport(AppTrackingTransparency)
            func promptTrackingAuthorization(completion: @escaping @Sendable (ATTrackingManager.AuthorizationStatus) -> Void) {
                completion(.notDetermined)
            }
        #endif
        
        func sendConversionValue(value: Int, coarseValue: String?, completion: @escaping ((any Error)?) -> Void) {
            completion(nil)
        }
        
        func setDataCollectionEnabled(_ enabled: Bool) {
        }
        
        func setAttributionDelegate(_ delegate: any KovaleeFramework.KovaleeAttributionDelegate) {
        }
    }
#endif
