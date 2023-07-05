import Foundation
import KovaleeFramework

// MARK: Revenue Cat Purchases
extension Kovalee {
    /// Set a specific userId for RevenueCat
    ///
    /// - Parameters:
    ///    - userId: a string representing the userId to be set
    public static func setRevenueCatUserId(userId: String) {
		Self.shared.kovaleeManager?.setRevenueCatUserId(userId: userId)
    }

    /// Retrieve the ``CustomerInfo`` for the current customer
    ///
    /// - Returns: current customer information
    public static func customerInfo() async throws -> CustomerInfo? {
		try await Self.shared.kovaleeManager?.customerInfo() as? CustomerInfo
    }

    /// Fetch ``Offerings`` if available
    ///
    /// - Returns: available offerings
    public static func fetchOfferings() async throws -> Offerings? {
		try await Self.shared.kovaleeManager?.fetchOfferings() as? Offerings
    }

    /// Fetch current ``Offering`` if available
    ///
    /// - Returns: available current offering
    public static func fetchCurrentOffering() async throws -> Offering? {
        try await Self.shared.kovaleeManager?.fetchCurrentOffering() as? Offering
    }

    /// Restore purchase previously made by current user
    ///
    /// - Parameters:
    ///    - fromSource: from where is the user making the purchase
    /// - Returns: current ``CustomerInfo``
    public static func restorePurchases(fromSource source: String) async throws -> CustomerInfo? {
		try await Self.shared.kovaleeManager?.restorePurchases(fromSource: source) as? CustomerInfo
    }

    /// Performs a purchase fo the specified ``Package``
    ///
    /// - Parameters:
    ///    - package: the package to be purchased
    ///    - fromSource: from where is the user making the purchase
    /// - Returns: the result of the purchase transation as ``PurchaseResultData``
    public static func purchase(package: Package, fromSource source: String) async throws -> PurchaseResultData? {
		try await Self.shared.kovaleeManager?.purchase(package: package, fromSource: source) as? PurchaseResultData
    }
}

// MARK: Purchase accessory methods
extension Kovalee {

	/// Use this method straight before starting a purchase
	///
	/// - Parameters:
	///    - duration: the subscription duration
	///    - source: from where is the user making the purchase
	public static func startedPurchasing(
		subscriptionWithDuration duration: Int,
		fromSource source: String
	) {
		Self.shared.kovaleeManager?.startedPurchasing(subscriptionWithDuration: duration, fromSource: source)
	}

	/// Use this method straight after a purchase has been successfully executed
	///
	/// - Parameters:
	///    - productId: the id of the purchased subscription
	///    - duration: the subscription duration
	///    - source: from where is the user making the purchase
	public static func succesfullyPurchased(
		subscriptionWithProductId productId: String,
		andDuration duration: Int,
		fromSource source: String
	) {
		Self.shared.kovaleeManager?.succesfullyPurchased(
			subscriptionWithProductId: productId,
			andDuration: duration,
			fromSource: source
		)
	}

	/// Use this method to tell the SDK a payment has been cancelled
	///
	/// - Parameters:
	///    - source: from where is the user making the purchase
	public static func paymentCancelledForSubscription(fromSource source: String) {
		Self.shared.kovaleeManager?.paymentCancelledForSubscription(fromSource: source)
	}

	/// Use this method to tell the SDK a subscription payment has failed
	///
	/// - Parameters:
	///    - duration: the subscription duration
	///    - source: from where is the user making the purchase
	public static func paymentFailed(
		forSubscriptionWithDuration duration: Int,
		fromSource source: String
	) {
		Self.shared.kovaleeManager?.paymentFailed(forSubscriptionWithDuration: duration, fromSource: source)
	}

	/// Use this method to tell the SDK a restore payment has failed
	///
	/// - Parameters:
	///    - source: from where is the user making the purchase
	public static func paymentRestoredFailed(fromSource source: String) {
		Self.shared.kovaleeManager?.paymentRestoredFailed(fromSource: source)
	}

	/// Use this method to tell the SDK a payment has been restore successfully
	///
	/// - Parameters:
	///    - source: from where is the user making the purchase
	public static func paymentRestored(fromSource source: String) {
		Self.shared.kovaleeManager?.paymentRestored(fromSource: source)
	}

	/// Use this method to tell the SDK that the current user is or is not premum
	///
	/// - Parameters:
	///    - premium: is the user premium
	public static func setIsUserPremium(_ premium: Bool) {
		Self.shared.kovaleeManager?.setIsUserPremium(premium)
	}
}
