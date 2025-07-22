import Foundation

// MARK: Purchase accessory methods

public extension Kovalee {
    /// Use this method straight before starting a purchase
    ///
    /// - Parameters:
    ///    - productId: the subscription Id
    ///    - source: from where is the user making the purchase
    static func startedPurchasing(
        subscriptionWithProductId productId: String,
        fromSource source: String
    ) {
        shared.kovaleeManager?.startedPurchasing(subscriptionWithId: productId, fromSource: source)
    }

    /// Use this method straight after a purchase has been successfully executed
    ///
    /// - Parameters:
    ///    - productId: the id of the purchased subscription
    ///    - duration: the subscription duration
    ///    - source: from where is the user making the purchase
    static func succesfullyPurchased(
        subscriptionWithProductId productId: String,
        andDuration _: Duration,
        fromSource source: String
    ) {
        shared.kovaleeManager?.succesfullyPurchased(
            subscriptionWithProductId: productId,
            fromSource: source
        )
    }

    /// Use this method to tell the SDK a payment has been cancelled
    ///
    /// - Parameters:
    ///    - source: from where is the user making the purchase
    static func paymentCancelledForSubscription(fromSource source: String) {
        shared.kovaleeManager?.paymentCancelledForSubscription(fromSource: source)
    }

    /// Use this method to tell the SDK a subscription payment has failed
    ///
    /// - Parameters:
    ///    - productId: the subscription Id
    ///    - source: from where is the user making the purchase
    static func paymentFailed(
        forSubscriptionWithId productId: String,
        fromSource source: String
    ) {
        shared.kovaleeManager?.paymentFailed(
            forSubscriptionWithId: productId,
            fromSource: source
        )
    }

    /// Use this method to tell the SDK a restore payment has failed
    ///
    /// - Parameters:
    ///    - source: from where is the user making the purchase
    static func paymentRestoredFailed(fromSource source: String) {
        shared.kovaleeManager?.paymentRestoredFailed(fromSource: source)
    }

    /// Use this method to tell the SDK a payment has startered restoring
    ///
    /// - Parameters:
    ///    - source: from where is the user making the purchase
    static func paymentRestoreStart(fromSource source: String) {
        shared.kovaleeManager?.paymentRestoredStart(fromSource: source)
    }

    /// Use this method to tell the SDK a payment has been restore successfully
    ///
    /// - Parameters:
    ///    - source: from where is the user making the purchase
    static func paymentRestored(fromSource source: String) {
        shared.kovaleeManager?.paymentRestored(fromSource: source)
    }

    /// Use this method to tell the SDK that the current user is or is not premum
    ///
    /// - Parameters:
    ///    - premium: is the user premium
    static func setIsUserPremium(_ premium: Bool) {
        shared.kovaleeManager?.setIsUserPremium(premium)
    }
}

/// Helper enum to map subscription duration to Int
public enum Duration {
    case day
    case month
    case week
    case year

    public static func create(fromIntValue value: Int) -> Self? {
        switch value {
        case 1:
            return .day
        case 7:
            return .week
        case 30:
            return .month
        case 365:
            return .year
        default:
            return nil
        }
    }

    public var inDays: Int {
        switch self {
        case .day:
            return 1
        case .month:
            return 30
        case .week:
            return 7
        case .year:
            return 365
        }
    }
}
