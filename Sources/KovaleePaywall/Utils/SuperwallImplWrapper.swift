import Foundation
import KovaleeFramework
import KovaleeRemoteConfig
import KovaleeSDK
import SuperwallKit
import SwiftUI

extension PaywallManagerCreator: Creator {
    public func createImplementation(
        withConfiguration configuration: Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager {
        guard let key = keys.superwall else {
            fatalError("No configuration Key for Superwall found in the Keys file")
        }

        let apiKey = configuration.environment == .production ?
            key.prodSDKId : (key.devSDKId ?? "")
        return SuperwallWrapperImpl(withApiKey: apiKey)
    }
}

extension Kovalee {
    /// Usefull in case of forcing AB tests variants for testing purposes
    static func paywallTriggerEventFromABTest() async -> String? {
        guard
            let kovaleeManager = Kovalee.shared.kovaleeManager,
            kovaleeManager.debugModeOn()
        else {
            return nil
        }

        return await Kovalee.abTestValue()
    }

    /// Remember to set paywall_test_running in firebase otherwise data won't be recorded
    static func handlePaywallABTest(withVariant variant: String) async {
        guard
            await experimentRunning(),
            let kovaleeManager = Kovalee.shared.kovaleeManager
        else {
            return
        }
        let currentDebugModeStatus = kovaleeManager.debugModeOn()
        kovaleeManager.setDebugMode(true)
        Kovalee.setAbTestValue(variant)
        kovaleeManager.setDebugMode(currentDebugModeStatus)
    }

    private static func experimentRunning() async -> Bool {
        guard let value = await Kovalee.remoteValue(forKey: .paywallTestRunning) else {
            KLogger.debug("❌ 💸 Key paywall_test_running not found")
            return false
        }

        return value.boolValue ?? false
    }
}

class SuperwallWrapperImpl: NSObject, PaywallManager, Manager {
    @AppStorage(.paywallSource) var paywallSource = ""

    init(withApiKey apiKey: String) {
        KLogger.debug("💸 Initializing Superwall")

        purchaseController = PurchaseManager()
        options = SuperwallOptions()
        super.init()

        options.logging.level = KLogger.logLevel.superwallKitLogLevel()

        Superwall.configure(
            apiKey: apiKey,
            purchaseController: purchaseController,
            options: options
        )

        Superwall.shared.delegate = self
        purchaseController.syncSubscriptionStatus()
    }

    private let purchaseController: PurchaseManager
    private let options: SuperwallOptions
    private var source: String?
}

extension SuperwallWrapperImpl: SuperwallDelegate {
    func handleSuperwallEvent(withInfo eventInfo: SuperwallEventInfo) {
        switch eventInfo.event {
        case let .paywallOpen(paywallInfo: info):
            Task {
                await Kovalee.handlePaywallABTest(withVariant: info.name)
                if let source {
                    Kovalee.sendEvent(event: BasicEvent.pageViewPaywall(source: source))
                }
            }
        case let .triggerFire(eventName, _):
            source = eventName
            paywallSource = eventName

        case .paywallPresentationRequest(status: _, reason: let reason):
            guard let reason else {
                return
            }

            switch reason {
            case let .holdout(experiment) where experiment.variant.type == .holdout:
                if let source {
                    Kovalee.sendEvent(event: BasicEvent.pageViewPaywall(source: source))
                }

            default:
                Kovalee.sendEvent(
                    withName: "paywall_error",
                    andProperties: ["error": reason.localizedDescription]
                )
            }
        default:
            return
        }
    }
}

extension KovaleeFramework.LogLevel {
    func superwallKitLogLevel() -> SuperwallKit.LogLevel {
        switch self {
        case .verbose, .debug:
            SuperwallKit.LogLevel.debug
        case .info:
            SuperwallKit.LogLevel.info
        case .warn:
            SuperwallKit.LogLevel.warn
        case .error:
            SuperwallKit.LogLevel.error
        @unknown default:
            SuperwallKit.LogLevel.none
        }
    }
}

