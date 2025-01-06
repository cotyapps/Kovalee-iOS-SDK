import KovaleePurchases
import KovaleeSDK
import RevenueCat
import StoreKit
import SuperwallKit
import SwiftUI

final class PurchaseManager: PurchaseController {
    @AppStorage(.isUserPremium) var isUserPremium = false
    @AppStorage(.paywallSource) var paywallSource = ""

    // MARK: Sync Subscription Status

    /// Makes sure that Superwall knows the customers subscription status by
    /// changing `Superwall.shared.subscriptionStatus`
    func syncSubscriptionStatus() {
        Task {
            Superwall.shared.identify(userId: Purchases.shared.appUserID)
            for await customerInfo in Purchases.shared.customerInfoStream {
                // Gets called whenever new CustomerInfo is available
                let hasActiveSubscription = !customerInfo.activeSubscriptions.isEmpty
                // Why? -> https://www.revenuecat.com/docs/entitlements#entitlements

                isUserPremium = hasActiveSubscription
                Superwall.shared.subscriptionStatus = hasActiveSubscription ? .active : .inactive
            }
        }
    }

    // MARK: Handle Purchases

    /// Makes a purchase with RevenueCat and returns its result. This gets called when
    /// someone tries to purchase a product on one of your paywalls.
    func purchase(product: SKProduct) async -> PurchaseResult {
        do {
            let result = try await Kovalee.purchaseSubscription(
                withId: product.productIdentifier,
                fromSource: paywallSource
            )
            if let result {
                if result.userCancelled {
                    return .cancelled
                } else if result.transaction != nil {
                    let hasActiveSubscription = !result.customerInfo.activeSubscriptions.isEmpty
                    isUserPremium = hasActiveSubscription
                    Kovalee.setIsUserPremium(isUserPremium)
                    Superwall.shared.subscriptionStatus = hasActiveSubscription ? .active : .inactive
                    return .purchased
                }
            }
        } catch let error as ErrorCode {
            return error == .paymentPendingError ? .pending : .failed(error)
        } catch {
            return .failed(error)
        }

        return .failed(ErrorCode.unknownError)
    }

    // MARK: Handle Restores

    /// Makes a restore with RevenueCat and returns `.restored`, unless an error is thrown.
    /// This gets called when someone tries to restore purchases on one of your paywalls.
    func restorePurchases() async -> RestorationResult {
        do {
            if let customerInfo = try await Kovalee.restorePurchases(fromSource: paywallSource) {
                let hasActiveSubscription = !customerInfo.activeSubscriptions.isEmpty
                isUserPremium = hasActiveSubscription
                Kovalee.setIsUserPremium(isUserPremium)
                Superwall.shared.subscriptionStatus = hasActiveSubscription ? .active : .inactive
                return hasActiveSubscription ? .restored : .failed(nil)
            } else {
                return .failed(nil)
            }
        } catch {
            Kovalee.paymentRestoredFailed(fromSource: paywallSource)
            return .failed(error)
        }
    }
}
