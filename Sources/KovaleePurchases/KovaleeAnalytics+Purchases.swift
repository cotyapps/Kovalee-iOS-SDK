import Foundation
import KovaleeSDK

// MARK: Revenue Cat Purchases
extension Kovalee {
	private func setupPurchaseManager() {
		guard Self.shared.kovaleeManager?.purchaseManager == nil else {
			return
		}

		guard let keys = self.keys.revenueCat else {
			fatalError("No configuration Key for RevenueCat found in the Keys file")
		}

		Self.shared.kovaleeManager?.setupPurchaseManager(
			purchaseManaegr: RevenueCatWrapperImpl(withKeys: keys)
		)
	}

    /// Set a specific userId for RevenueCat
    ///
    /// - Parameters:
    ///    - userId: a string representing the userId to be set
    public static func setRevenueCatUserId(userId: String) {
		Self.shared.setupPurchaseManager()

		Self.shared.kovaleeManager?.setRevenueCatUserId(userId: userId)
    }

    /// Retrieve the ``CustomerInfo`` for the current customer
    ///
    /// - Returns: current customer information
    public static func customerInfo() async throws -> CustomerInfo? {
		Self.shared.setupPurchaseManager()

		return try await Self.shared.kovaleeManager?.customerInfo() as? CustomerInfo
    }

    /// Fetch ``Offerings`` if available
    ///
    /// - Returns: available offerings
    public static func fetchOfferings() async throws -> Offerings? {
		Self.shared.setupPurchaseManager()

		return try await Self.shared.kovaleeManager?.fetchOfferings() as? Offerings
    }

    /// Fetch current ``Offering`` if available
    ///
    /// - Returns: available current offering
    public static func fetchCurrentOffering() async throws -> Offering? {
		Self.shared.setupPurchaseManager()

        return try await Self.shared.kovaleeManager?.fetchCurrentOffering() as? Offering
    }

    /// Restore purchase previously made by current user
    ///
    /// - Parameters:
    ///    - fromSource: from where is the user making the purchase
    /// - Returns: current ``CustomerInfo``
    public static func restorePurchases(fromSource source: String) async throws -> CustomerInfo? {
		Self.shared.setupPurchaseManager()

		return try await Self.shared.kovaleeManager?.restorePurchases(fromSource: source) as? CustomerInfo
    }

    /// Performs a purchase fo the specified ``Package``
    ///
    /// - Parameters:
    ///    - package: the package to be purchased
    ///    - fromSource: from where is the user making the purchase
    /// - Returns: the result of the purchase transation as ``PurchaseResultData``
    public static func purchase(package: Package, fromSource source: String) async throws -> PurchaseResultData? {
		Self.shared.setupPurchaseManager()

		return try await Self.shared.kovaleeManager?.purchase(package: package, fromSource: source) as? PurchaseResultData
    }
}
