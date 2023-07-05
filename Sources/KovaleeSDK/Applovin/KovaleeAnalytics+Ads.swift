import Foundation
import KovaleeFramework

// MARK: Applovin
extension Kovalee {
    /// Configure FB ad ``FBAdProcessingOptions``
//    public static func setupfbAdProcessingOptions(options: FBAdProcessingOptions) async {
//        await Self.shared.kovaleeManager?.setupfbAdProcessingOptions(options: options)
//    }

    /// Displays the Mediation Debugger screen to check if the mediated networks aare configured correctly
    public static func showMediationDebugger() {
        Self.shared.kovaleeManager?.showMediationDebugger()
    }

    /// Setup and, when ready, displays an interstitial ad.
    public static func displayInterstitialAd() {
        Self.shared.kovaleeManager?.displayInterstitialAd()
    }

    /// Setup and, when ready, displays a rewarded ad.
    ///
    /// Once the user has seen the whole ad, a completion block is returned
    /// To get the return value using Swift async/awat, use: ``displayInterstitialAd()`
    /// `
    /// - Parameters:
    ///    - completion: the completion called once the user has see the ad.
    public static func displayRewardedAd(andRewardCompletion completion: (() -> Void)?) {
        Self.shared.kovaleeManager?.displayRewardedAd(andRewardCompletion: completion)
    }

    /// Setup and, when ready, displays a rewarded ad.
    ///
    /// It returns once the user has seen the whole ad
    ///
    /// To get the return value in a trailing closure, use: ``displayRewardedAd(andRewardCompletion:)``
    public static func displayRewardedAd() async {
		await Self.shared.kovaleeManager?.displayRewardedAd()
    }
}
