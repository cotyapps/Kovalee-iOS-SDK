import Foundation
import KovaleeFramework
import KovaleeSDK
import RevenueCat

extension PurchaseManagerCreator: @retroactive Creator {
    public func createImplementation(
        withConfiguration _: KovaleeSDK.Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager {
        guard let key = keys.revenueCat else {
            fatalError("No configuration Key for RevenueCat found in the Keys file")
        }

        return RevenueCatWrapperImpl(withKeys: key)
    }
}

// MARK: Revenue Cat Purchases

public extension Kovalee {
    /// Set a specific userId for RevenueCat
    ///
    /// - Parameters:
    ///    - userId: a string representing the userId to be set
    @available(swift, deprecated: 1.5.5, message: "Please migrate to setRevenueCatUserId async method")
    static func setRevenueCatUserId(userId: String) {
        shared.kovaleeManager?.setRevenueCatUserId(userId: userId)
    }

    /// Set a specific userId for RevenueCat.
    /// The function is async and can throw
    ///
    /// - Parameters:
    ///    - userId: a string representing the userId to be set
    /// - Returns:
    ///    - customerInfo: customer information
    ///    - created: returns true if the user has been created
    static func setRevenueCatUserId(userId: String) async throws -> (info: CustomerInfo, created: Bool) {
        guard let manager = shared.kovaleeManager else {
            throw PurchaseError.initializationProblem
        }
        return try await manager.setRevenueCatUserId(userId: userId) as! (CustomerInfo, created: Bool)
    }

    /// Set a specific userId for RevenueCat.
    /// The function is async and can throw
    ///
    /// - Parameters:
    ///    - userId: a string representing the userId to be set
    /// - Returns:
    ///    - customerInfo: customer information
    ///    - created: returns true if the user has been created
    static func setRevenueCatUserId(
        userId: String,
        withCompletion completion: @escaping (Result<(info: CustomerInfo, created: Bool), Error>) -> Void
    ) {
        Task {
            do {
                let result = try await Self.setRevenueCatUserId(userId: userId)
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    /// Logout the current user from RevenueCat.
    /// The function is async and can throw
    ///
    /// - Returns:
    ///    - customerInfo: customer information
    static func logoutRevenueCatUser() async throws -> CustomerInfo {
        guard let manager = shared.kovaleeManager else {
            throw PurchaseError.initializationProblem
        }
        return try await manager.logoutRevenueCatUser() as! CustomerInfo
    }

    /// Logout the current user from RevenueCat.
    /// The function is async and can throw
    ///
    /// - Returns:
    ///    - customerInfo: customer information
    static func logoutRevenueCatUser(
        withCompletion completion: @escaping (Result<CustomerInfo, Error>) -> Void
    ) {
        Task {
            do {
                let result = try await Self.logoutRevenueCatUser()
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    /// Retrieve the ``CustomerInfo`` for the current customer
    ///
    /// - Returns: current customer information
    static func customerInfo() async throws -> CustomerInfo? {
        try await shared.kovaleeManager?.customerInfo() as? CustomerInfo
    }

    /// Retrieve the ``CustomerInfo`` for the current customer
    ///
    /// - Parameters:
    ///    - completion: current customer information if returned.
    static func customerInfo(
        withCompletion completion: @escaping (Result<CustomerInfo?, Error>) -> Void
    ) {
        Task {
            do {
                let result = try await Self.customerInfo()
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    /// Set a user email for RevenueCat
    ///
    /// - Parameters:
    ///    - email: a string representing the email to be set
    static func setRevenueCatEmail(email: String) {
        shared.kovaleeManager?.setRevenueCatEmail(email: email)
    }

    /// Checks if the current user has an active premium subscription or entitlement.
    ///
    /// This method is asynchronous and may throw an error if the user information
    /// cannot be retrieved.
    ///
    /// - Returns: A `Bool` indicating whether the user has an active premium status.
    ///            Returns `true` if the user has active subscriptions or entitlements,
    ///            and `false` otherwise.
    ///
    /// - Throws: An error if there is a problem fetching the user information.
    static func isUserPremium() async throws -> Bool {
        guard let customerInfo = try await Self.customerInfo() else {
            return false
        }
        return !customerInfo.activeSubscriptions.isEmpty || customerInfo.activeEntitlements
    }

    /// Sync the purchases for the current customer
    ///
    /// - Returns: current customer information
    static func syncPurchases() async throws -> CustomerInfo? {
        try await shared.kovaleeManager?.syncPurchase() as? CustomerInfo
    }

    /// Sync the purchases for the current customer
    ///
    /// - Parameters:
    ///    - completion: current customer information
    static func syncPurchases(
        withCompletion completion: @escaping (Result<CustomerInfo?, Error>) -> Void
    ) {
        Task {
            do {
                let result = try await Self.syncPurchases()
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    /// Fetch ``Offerings`` if available
    ///
    /// - Returns: available offerings
    static func fetchOfferings() async throws -> Offerings? {
        try await shared.kovaleeManager?.fetchOfferings() as? Offerings
    }

    /// Fetch ``Offerings`` if available
    ///
    /// - Parameters:
    ///    - completion: available offerings
    static func fetchOfferings(
        withCompletion completion: @escaping (Result<Offerings?, Error>) -> Void
    ) {
        Task {
            do {
                let result = try await Self.fetchOfferings()
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    /// Fetch current ``Offering`` if available
    ///
    /// - Returns: available current offering
    static func fetchCurrentOffering() async throws -> Offering? {
        try await shared.kovaleeManager?.fetchCurrentOffering() as? Offering
    }

    /// Fetch current ``Offering`` if available
    ///
    /// - Parameters:
    ///    - completion: available offering
    static func fetchCurrentOffering(
        withCompletion completion: @escaping (Result<Offering?, Error>) -> Void
    ) {
        Task {
            do {
                let result = try await Self.fetchCurrentOffering()
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    /// Restore purchase previously made by current user
    ///
    /// - Parameters:
    ///    - fromSource: from where is the user making the purchase
    /// - Returns: current ``CustomerInfo``
    static func restorePurchases(fromSource source: String) async throws -> CustomerInfo? {
        try await shared.kovaleeManager?.restorePurchases(fromSource: source) as? CustomerInfo
    }

    /// Restore purchase previously made by current user
    ///
    /// - Parameters:
    ///    - fromSource: from where is the user making the purchase
    ///    - completion: current ``CustomerInfo``
    static func restorePurchases(
        fromSource source: String,
        withCompletion completion: @escaping (Result<CustomerInfo?, Error>) -> Void
    ) {
        Task {
            do {
                let result = try await Self.restorePurchases(fromSource: source)
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    /// Performs a purchase fo the specified ``Package``
    ///
    /// - Parameters:
    ///    - package: the package to be purchased
    ///    - fromSource: from where is the user making the purchase
    /// - Returns: the result of the purchase transaction as ``PurchaseResultData``
    static func purchase(package: Package, fromSource source: String) async throws -> PurchaseResultData? {
        try await shared.kovaleeManager?.purchase(package: package, fromSource: source) as? PurchaseResultData
    }

    /// Performs a purchase of the specified ``Package``
    ///
    /// - Parameters:
    ///    - package: the package to be purchased
    ///    - fromSource: from where is the user making the purchase
    ///    - completion: the result of the purchase transaction as ``PurchaseResultData``
    static func purchase(
        package: Package,
        fromSource source: String,
        withCompletion completion: @escaping (Result<PurchaseResultData?, Error>) -> Void
    ) {
        Task {
            do {
                let result = try await Self.purchase(package: package, fromSource: source)
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    /// Performs a purchase of a subscription with specified Id and duration
    ///
    /// - Parameters:
    ///    - subscriptionId: the id of the product to be purchased
    ///    - fromSource: from where is the user making the purchase
    /// - Returns: the result of the purchase transaction as ``PurchaseResultData``
    static func purchaseSubscription(
        withId subscriptionId: String,
        fromSource source: String
    ) async throws -> PurchaseResultData? {
        guard
            let offerings = try await shared.kovaleeManager?.fetchOfferings() as? Offerings,
            let package = offerings.returnOffering(withSubscriptionId: subscriptionId)
        else {
            return nil
        }

        return try await Self.shared.kovaleeManager?.purchase(package: package, fromSource: source) as? PurchaseResultData
    }

    /// Performs a purchase of a subscription with specified Id and duration
    ///
    /// - Parameters:
    ///    - subscriptionId: the id of the product to be purchased
    ///    - fromSource: from where is the user making the purchase
    ///    - completion: the result of the purchase transaction as ``PurchaseResultData``
    static func purchaseSubscription(
        withId subscriptionId: String,
        fromSource source: String,
        withCompletion completion: @escaping (Result<PurchaseResultData?, Error>) -> Void
    ) {
        Task {
            do {
                let result = try await Self.purchaseSubscription(
                    withId: subscriptionId,
                    fromSource: source
                )
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    static func revenueCatUserId() -> String {
        shared.kovaleeManager?.revenueCatUserId() ?? ""
    }

    static func checkTrialOrIntroDiscountEligibility(productIdentifiers: [String]) async -> [String: IntroEligibilityStatus] {
        await shared.kovaleeManager?
            .checkTrialOrIntroDiscountEligibility(productIdentifiers: productIdentifiers)?
            .compactMapValues { IntroEligibilityStatus(rawValue: $0) } ?? [:]
    }

    static func checkTrialOrIntroDiscountEligibility(
        productIdentifiers: [String],
        withCompletion completion: @escaping ([String: IntroEligibilityStatus]) -> Void
    ) async {
        Task {
            completion(await Self.checkTrialOrIntroDiscountEligibility(productIdentifiers: productIdentifiers))
        }
    }

    static func setPurchasesDelegate(_ delegate: KovaleePurchasesDelegate) {
        shared.kovaleeManager?.setPurchaseDelegate(delegate)
    }
}

// MARK: - Bundle

public extension Kovalee {
    /// Checks if a user is part of a specific bundle.
    ///
    /// This method queries the Kovalee manager to determine if a user, identified by their email,
    /// is included in a particular bundle for the current app.
    ///
    /// - Parameters:
    ///   - email: A String containing the email address of the user to check.
    /// - Returns: A Boolean value. `true` if the user is in the bundle, `false` otherwise.
    static func isUserInBundle(
        email: String
    ) async throws -> Bool {
        guard let manager = shared.kovaleeManager else {
            throw PurchaseError.initializationProblem
        }
        return try await manager.isUserInBundle(email: email)
    }

    /// Removes the current user from their associated bundle.
    ///
    /// This static method attempts to logout the current user from any bundle they are associated with.
    static func removeUserFromBundle() {
        shared.kovaleeManager?.removeUserFromBundle()
    }
}
