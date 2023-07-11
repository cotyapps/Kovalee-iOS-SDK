import AppLovinSDK
import FBAudienceNetwork
import KovaleeFramework

class ApplovinWrapperImpl: NSObject, ApplovinWrapper {
    init(withKey key: KovaleeKeys.Applovin) {
		Logger.debug("📺 initializing Applovin")

        self.key = key
        self.sdk = ALSdk.shared(withKey: key.sdkId)
        self.sdk?.mediationProvider = "max"
        self.sdk?.settings.isVerboseLoggingEnabled = Logger.logLevel.applovinLogLevel()

		if let sdk = self.sdk {
			self.interstitialAd = MAInterstitialAd(
				adUnitIdentifier: key.interstitialUnitId,
				sdk: sdk
			)

			self.rewardedAd = MARewardedAd.shared(
				withAdUnitIdentifier: key.rewardedUnitId,
				sdk: sdk
			)
		}
        // TODO: check this user Id
//        ALSdk.shared()!.userIdentifier = "USER_ID"
    }

	func setupfbAdProcessingOptions(options: AbstractFBAdProcessingOptions) async {
		self.configuration = await self.sdk?.initializeSdk()

        if configuration?.appTrackingTransparencyStatus == .authorized {
            FBAdSettings.setAdvertiserTrackingEnabled(options.advertiserTrackingEnabled)
        }

        if options.enableLDU {
            FBAdSettings.setDataProcessingOptions(
                ["LDU"],
                country: options.isCountryUS ? 1 : 0,
                state: options.isStateCalifornia ? 1000 : 0
            )
        } else {
            FBAdSettings.setDataProcessingOptions([])
        }
    }

	func createInterstitialAd(onClose: (() -> Void)?) {
        guard let sdk, sdk.isInitialized else {
            Logger.error("📺 Failed to load ad: Applovin is not initialized correctly")
            return
        }
		onAdClose = onClose
		interstitialAd?.delegate = self
        
        // Load the first ad
        interstitialAd?.load()
    }

    func createRewardedAd(completedVideo completion: (() -> Void)?) {
        guard let sdk, sdk.isInitialized else {
            Logger.error("📺 Failed to load ad: Applovin is not initialized correctly")
            return
        }
        didCompleteRewardedVideo = completion

        rewardedAd?.delegate = self

        // Load the first ad
        rewardedAd?.load()
    }

    func showMediationDebugger() {
        self.sdk?.showMediationDebugger()
    }

    private let key: KovaleeKeys.Applovin
    private let sdk: ALSdk?
    private var configuration: ALSdkConfiguration?
    private var interstitialAd: MAInterstitialAd?
    private var rewardedAd: MARewardedAd?
    private var retryAttempt = 0.0

	private var onAdClose: (() -> Void)?
    private var didCompleteRewardedVideo: (() -> Void)?
}

// swiftlint:disable identifier_name
extension ApplovinWrapperImpl: MAAdDelegate, MARewardedAdDelegate {
    func didLoad(_ ad: AppLovinSDK.MAAd) {
        Logger.debug("📺 Ad ready to be shown")
        // Reset retry attempt
        retryAttempt = 0

        interstitialAd?.show()
        rewardedAd?.show()
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        // ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        retryAttempt += 1
        let delaySec = pow(2.0, min(6.0, retryAttempt))

        Logger.error("📺 Failed to load ad with unitId: \(adUnitIdentifier)")
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            self.interstitialAd?.load()
            self.rewardedAd?.load()
        }
    }

    func didDisplay(_ ad: AppLovinSDK.MAAd) {}

	func didHide(_ ad: MAAd) {
		Logger.debug("📺 Ad has been hidden")
		onAdClose?()
		onAdClose = nil
    }

    func didClick(_ ad: AppLovinSDK.MAAd) {}

    func didFail(toDisplay ad: AppLovinSDK.MAAd, withError error: MAError) {
		Logger.debug("📺 Failed to display ads")
    }

    func didRewardUser(for ad: AppLovinSDK.MAAd, with reward: MAReward) {
		Logger.debug("📺 Rewarded ad has been seen")
        didCompleteRewardedVideo?()
		didCompleteRewardedVideo = nil
    }
}
// swiftlint:enable identifier_name

/// Options for setting up FB ad Processing'
public struct FBAdProcessingOptions: AbstractFBAdProcessingOptions {
    public var enableLDU: Bool
    public var isCountryUS: Bool
    public var isStateCalifornia: Bool

    public var advertiserTrackingEnabled: Bool
}

extension LogLevel {
    func applovinLogLevel() -> Bool {
        switch self {
        case .info, .verbose, .debug, .warn:
            return true
        default:
            return false
        }
    }
}
