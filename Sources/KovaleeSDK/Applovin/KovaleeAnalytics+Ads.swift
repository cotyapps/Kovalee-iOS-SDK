import Foundation
import KovaleeFramework

// MARK: Applovin
extension Kovalee {
	/// Configure FB ad ``FBAdProcessingOptions``
	public static func setupfbAdProcessingOptions(options: FBAdProcessingOptions) async {
		await Self.shared.kovaleeManager?.setupfbAdProcessingOptions(options: options)
	}
	
	/// Displays the Mediation Debugger screen to check if the mediated networks aare configured correctly
	public static func showMediationDebugger() {
		Self.shared.kovaleeManager?.showMediationDebugger()
	}

	/// Loads an interstitial ad
	///
	/// It returns once the ad has been loaded
	public static func loadInterstitialAd() async -> Bool? {
		await Self.shared.kovaleeManager?.loadInterstitialAd()
	}

	/// Loads a rewarded ad
	///
	/// It returns once the ad has been loaded
	public static func loadRewardedAd() async -> Bool? {
		await Self.shared.kovaleeManager?.loadRewardedAd()
	}

	/// Displays an interstitial ad if ready
	///
	/// It returns once the user has seen the whole ad
	public static func displayInterstitialAd() async -> Bool? {
		await Self.shared.kovaleeManager?.showInterstitialAd()
	}

	/// Displays a rewarded ad if ready
	///
	/// It returns once the user has seen the whole ad
	public static func displayRewardedAd() async -> Bool? {
		await Self.shared.kovaleeManager?.showRewardedAd()
	}
}
