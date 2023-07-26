import Foundation
import KovaleeSDK

// MARK: Applovin
extension Kovalee {
	private func setupAdsManagerManager() {
		guard Self.shared.kovaleeManager?.adsManager == nil else {
			return
		}

		guard let keys = self.keys.applovin else {
			fatalError("No configuration Key for Applovin found in the Keys file")
		}

		Self.shared.kovaleeManager?.setupAdsManager(
			adsManager: ApplovinWrapperImpl(withKey: keys)
		)
	}

	/// Configure FB ad ``FBAdProcessingOptions``
	public static func setupfbAdProcessingOptions(options: FBAdProcessingOptions) async {
		Self.shared.setupAdsManagerManager()

		await Self.shared.kovaleeManager?.setupfbAdProcessingOptions(options: options)
	}
	
	/// Displays the Mediation Debugger screen to check if the mediated networks aare configured correctly
	public static func showMediationDebugger() {
		Self.shared.setupAdsManagerManager()

		Self.shared.kovaleeManager?.showMediationDebugger()
	}

	/// Loads an interstitial ad
	///
	/// It returns once the ad has been loaded
	public static func loadInterstitialAd() async -> Bool? {
		Self.shared.setupAdsManagerManager()

		return await Self.shared.kovaleeManager?.loadInterstitialAd()
	}

	/// Loads a rewarded ad
	///
	/// It returns once the ad has been loaded
	public static func loadRewardedAd() async -> Bool? {
		Self.shared.setupAdsManagerManager()

		return await Self.shared.kovaleeManager?.loadRewardedAd()
	}

	/// Displays an interstitial ad if ready
	///
	/// It returns once the user has seen the whole ad
	public static func displayInterstitialAd() async -> Bool? {
		Self.shared.setupAdsManagerManager()

		return await Self.shared.kovaleeManager?.showInterstitialAd()
	}

	/// Displays a rewarded ad if ready
	///
	/// It returns once the user has seen the whole ad
	public static func displayRewardedAd() async -> Bool? {
		Self.shared.setupAdsManagerManager()

		return await Self.shared.kovaleeManager?.showRewardedAd()
	}
}
