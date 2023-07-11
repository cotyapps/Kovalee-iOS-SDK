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
	
	/// Setup and, when ready, displays an interstitial ad.
	///
	/// It returns once the user has seen the whole ad
	public static func displayInterstitialAd() async {
		await withCheckedContinuation { continuation in
			Self.shared.kovaleeManager?.displayInterstitialAd {
				continuation.resume()
			}
		}
	}
	
	/// Setup and, when ready, displays a rewarded ad.
	///
	/// It returns once the user has seen the whole ad
	public static func displayRewardedAd() async {
		await withCheckedContinuation { continuation in
			Self.shared.kovaleeManager?.displayRewardedAd(andRewardCompletion: {
				continuation.resume()
			})
		}
	}
}
