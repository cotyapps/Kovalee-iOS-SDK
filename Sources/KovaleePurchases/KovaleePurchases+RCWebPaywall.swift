import KovaleeFramework
import KovaleeSDK
import RevenueCat
import SwiftUI
import UIKit

public enum WebPurchaseRedemptionError: Error {
    case newLinkSentToEmail(obfuscatedEmail: String)
    case invalidToken
    case otherError(String)
    case purchaseBelongsToOtherUser
}

// MARK: - RevenueCat Web Paywalls

public extension Kovalee {

    static func checkWebRedemptionURL(_ url: URL) async throws -> Bool {
        if let webPurchaseRedemption = url.asWebPurchaseRedemption,
           Purchases.isConfigured {
               let result = await Purchases.shared.redeemWebPurchase(webPurchaseRedemption)
               switch result {
               case let .success(infos):
                   let isPremium = try await isUserPremium()
                   if isPremium {
                       Kovalee.setUserProperty(key: "web_premium", value: "true")
                   }
                   return isPremium
               case let .error(error):
                   throw WebPurchaseRedemptionError.otherError(error.localizedDescription)
               case .invalidToken:
                   throw WebPurchaseRedemptionError.invalidToken
               case .purchaseBelongsToOtherUser:
                   throw WebPurchaseRedemptionError.purchaseBelongsToOtherUser
               case let .expired(obfuscatedEmail):
                   throw WebPurchaseRedemptionError.newLinkSentToEmail(obfuscatedEmail: obfuscatedEmail)
               }
        } else {
            return false
        }
    }

}

private struct WebPurchaseRedemptionModifier: ViewModifier {

    var isUserPremium: @MainActor (Bool) -> Void
    var onError: @MainActor (WebPurchaseRedemptionError) -> Void

    func body(content: Content) -> some View {
        content.onOpenURL { url in
            Task {
                do {
                    let isPremium = try await Kovalee.checkWebRedemptionURL(url)
                    isUserPremium(isPremium)
                } catch {
                    if let redemptionError = error as? WebPurchaseRedemptionError {
                        onError(redemptionError)
                    } else {
                        onError(.otherError(error.localizedDescription))
                    }
                }
            }
        }
    }

}

public extension View {
    /// Applies the `WebPurchaseRedemption` to the view, enabling it to check web purchase redemption url.
    ///
    /// - Parameters:
    ///   - isUserPremium: A closure that updates the UI based on the web user's premium status.
    ///   - onError: A closure that handles errors encountered while checking the premium status.
    /// - Returns: A modified view that listens for deep link URLs and updates the premium status accordingly.
    func onCheckWebRedemption(
        isUserPremium: @escaping @MainActor (Bool) -> Void,
        onError: @escaping @MainActor (WebPurchaseRedemptionError) -> Void
    ) -> some View {
        modifier(WebPurchaseRedemptionModifier(isUserPremium: isUserPremium, onError: onError))
    }
}
