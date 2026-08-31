import Foundation
import KovaleeFramework
import KovaleeSDK
import RevenueCat

extension PurchaseManagerCreator: Creator {
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
    /// Set a specific userId for RevenueCat.
    /// The function is async and can throw
    ///
    /// - Parameters:
    ///    - userId: a string representing the userId to be set
    /// - Returns:
    ///    - customerInfo: customer information
    ///    - created: returns true if the user has been created
    static func setRevenueCatUserId(userId: String) async throws -> (info: KCustomerInfo, created: Bool) {
        guard let manager = shared.kovaleeManager else {
            throw PurchaseError.initializationProblem
        }
        guard
            let customerInfo = try await manager.setRevenueCatUserId(userId: userId) as? (KCustomerInfo, created: Bool)
        else {
            throw PurchaseError.rcNotYetInitialized
        }
        return customerInfo
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
        withCompletion completion: @escaping @Sendable (Result<(info: KCustomerInfo, created: Bool), Error>) -> Void
    ) {
        let userIdCopy = userId // Create local copy
        Task { @Sendable in
            do {
                let result = try await Self.setRevenueCatUserId(userId: userIdCopy)
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                let capturedError = error // Capture error locally
                DispatchQueue.main.async {
                    completion(Result.failure(capturedError))
                }
            }
        }
    }

    /// Logout the current user from RevenueCat.
    /// The function is async and can throw
    ///
    /// - Returns:
    ///    - customerInfo: customer information
    static func logoutRevenueCatUser() async throws -> KCustomerInfo {
        guard let manager = shared.kovaleeManager else {
            throw PurchaseError.initializationProblem
        }
        guard let customerInfo = try await manager.logoutRevenueCatUser() as? KCustomerInfo else {
            throw PurchaseError.rcNotYetInitialized
        }

        return customerInfo
    }

    /// Logout the current user from RevenueCat.
    /// The function is async and can throw
    ///
    /// - Returns:
    ///    - customerInfo: customer information
    static func logoutRevenueCatUser(
        withCompletion completion: @escaping @Sendable (Result<KCustomerInfo, Error>) -> Void
    ) {
        Task { @Sendable in
            do {
                let result = try await Self.logoutRevenueCatUser()
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                let capturedError = error // Capture error locally
                DispatchQueue.main.async {
                    completion(Result.failure(capturedError))
                }
            }
        }
    }

    /// Retrieve the ``CustomerInfo`` for the current customer
    ///
    /// - Returns: current customer information
    static func customerInfo() async throws -> KCustomerInfo? {
        try await shared.kovaleeManager?.customerInfo() as? KCustomerInfo
    }

    /// Retrieve the ``CustomerInfo`` for the current customer
    ///
    /// - Parameters:
    ///    - completion: current customer information if returned.
    static func customerInfo(
        withCompletion completion: @escaping @Sendable (Result<KCustomerInfo?, Error>) -> Void
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

    /// Retrieve the ``CustomerInfo`` for the current customer, choosing how fresh it must be.
    ///
    /// Use ``KCustomerInfoFetchPolicy/fetchCurrent`` when a stale answer would be wrong — for
    /// example when deciding whether to warn about overlapping subscriptions, where cached data
    /// can still show a subscription the user cancelled moments ago. It always hits the network,
    /// so prefer the cached path for anything called on every view appearance.
    ///
    /// - Parameters:
    ///    - fetchPolicy: how fresh the returned customer info must be
    /// - Returns: current customer information
    /// - Throws: if the SDK is not initialized, or if no customer info could be produced. States
    ///   where ``customerInfo()`` returns `nil` surface here as errors, since the result is
    ///   non-optional. For ``KCustomerInfoFetchPolicy/fetchCurrent``, also throws when the fetch
    ///   fails — a failed forced fetch never falls back to cached data.
    ///
    /// - Note: ``KCustomerInfoFetchPolicy/cachedOrFetched`` throws `KovaleeError.userAlreadyInBundle`
    ///   for users in a Kovalee bundle, exactly like ``customerInfo()``.
    ///   ``KCustomerInfoFetchPolicy/fetchCurrent`` does **not** — it queries RevenueCat directly and
    ///   returns the store's view of the customer regardless of bundle membership. It is a pure
    ///   read: unlike the cached path, it does not update the `premium` user property.
    static func customerInfo(fetchPolicy: KCustomerInfoFetchPolicy) async throws -> KCustomerInfo {
        guard shared.kovaleeManager != nil else {
            throw PurchaseError.initializationProblem
        }

        switch fetchPolicy {
        case .cachedOrFetched:
            // Same call as the no-argument `customerInfo()`; the one contract difference at this
            // signature is that a `nil` result becomes an error, because the return is non-optional.
            guard let info = try await Self.customerInfo() else {
                throw PurchaseError.rcNotYetInitialized
            }
            return info

        case .fetchCurrent:
            guard Purchases.isConfigured else {
                throw PurchaseError.rcNotYetInitialized
            }
            // Pure read — deliberately no `setIsUserPremium` mirror. The manager only mirrors
            // premium status for non-bundle users (its bundle check isn't readable from here),
            // and a bundle user's premium comes from another Kovalee app: mirroring this app's
            // store-only view would flip their `premium` property to "no".
            return KCustomerInfo(info: try await Purchases.shared.customerInfo(fetchPolicy: .fetchCurrent))
        }
    }

    /// Retrieve the ``CustomerInfo`` for the current customer, choosing how fresh it must be.
    ///
    /// - Parameters:
    ///    - fetchPolicy: how fresh the returned customer info must be
    ///    - completion: current customer information
    static func customerInfo(
        fetchPolicy: KCustomerInfoFetchPolicy,
        withCompletion completion: @escaping @Sendable (Result<KCustomerInfo, Error>) -> Void
    ) {
        Task { @Sendable in
            do {
                let result = try await Self.customerInfo(fetchPolicy: fetchPolicy)
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

    /// Look up store products by identifier, independently of the configured offerings.
    ///
    /// Products a customer already owns are frequently absent from every current offering —
    /// grandfathered price points, retired products, or products belonging to another offering.
    /// This resolves them straight from StoreKit so their title, price and subscription group are
    /// available for display.
    ///
    /// - Parameters:
    ///    - productIdentifiers: the product identifiers to resolve
    /// - Returns: the products that resolved, in no guaranteed order. Identifiers that do not
    ///   resolve are omitted; note this does not distinguish an unknown product from a failed
    ///   StoreKit request, so an empty result is not proof the identifiers are invalid.
    static func products(productIdentifiers: [String]) async -> [KStoreProduct] {
        guard Purchases.isConfigured else {
            KLogger.debug("🛍️ Cannot fetch products: RevenueCat is not configured yet")
            return []
        }

        let products = await Purchases.shared.products(productIdentifiers)
        KLogger.debug("🛍️ Resolved \(products.count)/\(productIdentifiers.count) requested products")

        return products.map { KStoreProduct($0) }
    }

    /// Look up store products by identifier, independently of the configured offerings.
    ///
    /// - Parameters:
    ///    - productIdentifiers: the product identifiers to resolve
    ///    - completion: the products that resolved
    static func products(
        productIdentifiers: [String],
        withCompletion completion: @escaping @Sendable ([KStoreProduct]) -> Void
    ) {
        Task { @Sendable in
            let result = await Self.products(productIdentifiers: productIdentifiers)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    /// Cancel Web Subscription for the current user will only works if user has an active Stripe subscription
    ///
    static func cancelStripeSubscription() async throws -> Bool {
        guard let customerInfo = try await Self.customerInfo(),
              !customerInfo.entitlements.active.filter({ $0.value.store == KStore.stripe }).isEmpty else {
            return false
        }
        return try await shared.kovaleeManager?.cancelStripeSubscription() ?? false
    }

    /// Check active stripe subscription for the current user will only works if user has an active Stripe subscription
    ///
    static func hasActiveStripeSubscription() async throws -> Bool {
        guard let customerInfo = try await Self.customerInfo(),
              !customerInfo.entitlements.active.filter({ $0.value.store == KStore.stripe }).isEmpty else {
            return false
        }
        return try await shared.kovaleeManager?.hasActiveStripeSubscription() ?? false
    }

    /// Show RevenueCat Billing subscription  management Flow
    ///
    static func showManageSubscriptionsIfAvailable() async throws -> Bool {
        #if os(iOS) || os(macOS)
            guard let customerInfo = try await Self.customerInfo(),
                  !customerInfo.entitlements.active.filter({ $0.value.store == KStore.rcBilling }).isEmpty,
                  let _ = customerInfo.managementURL else {
                return false
            }
            do {
                try await Purchases.shared.showManageSubscriptions()
                return true
            } catch {
                return false
            }
        #else
            return false
        #endif
    }


    /// Check if user has a manageable RevenueCat Billing subscription for the current user
    ///
    static func hasManageableWebSubscription() async throws -> Bool {
        guard let customerInfo = try await Self.customerInfo() else {
            return false
        }
        return !customerInfo.entitlements.active.filter { $0.value.store == KStore.rcBilling }.isEmpty
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
    static func syncPurchases() async throws -> KCustomerInfo? {
        try await shared.kovaleeManager?.syncPurchase() as? KCustomerInfo
    }

    /// Sync the purchases for the current customer
    ///
    /// - Parameters:
    ///    - completion: current customer information
    static func syncPurchases(
        withCompletion completion: @escaping @Sendable (Result<KCustomerInfo?, Error>) -> Void
    ) {
        Task { @Sendable in
            do {
                let result = try await Self.syncPurchases()
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                let capturedError = error // Capture error locally
                DispatchQueue.main.async {
                    completion(Result.failure(capturedError))
                }
            }
        }
    }

    /// Fetch ``Offerings`` if available
    ///
    /// - Returns: available offerings
    static func fetchOfferings() async throws -> KOfferings? {
        try await shared.kovaleeManager?.fetchOfferings() as? KOfferings
    }

    /// Fetch ``Offerings`` if available
    ///
    /// - Parameters:
    ///    - completion: available offerings
    static func fetchOfferings(
        withCompletion completion: @escaping @Sendable (Result<KOfferings?, Error>) -> Void
    ) {
        Task { @Sendable in
            do {
                let result = try await Self.fetchOfferings()
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                let capturedError = error // Capture error locally
                DispatchQueue.main.async {
                    completion(Result.failure(capturedError))
                }
            }
        }
    }

    /// Fetch current ``Offering`` if available
    ///
    /// - Returns: available current offering
    static func fetchCurrentOffering() async throws -> KOffering? {
        try await shared.kovaleeManager?.fetchCurrentOffering() as? KOffering
    }

    /// Fetch current ``Offering`` if available
    ///
    /// - Parameters:
    ///    - completion: available offering
    static func fetchCurrentOffering(
        withCompletion completion: @escaping @Sendable (Result<KOffering?, Error>) -> Void
    ) {
        Task { @Sendable in
            do {
                let result = try await Self.fetchCurrentOffering()
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                let capturedError = error // Capture error locally
                DispatchQueue.main.async {
                    completion(Result.failure(capturedError))
                }
            }
        }
    }

    /// Fetch the current ``Offering`` for a RevenueCat targeting placement.
    ///
    /// Use this to serve different offerings at different points in your app
    /// (e.g. `"first_paywall"` vs `"repeat_paywall"`) without hardcoding offering
    /// identifiers. The placement targeting rules configured in the RevenueCat
    /// dashboard are resolved server-side.
    ///
    /// Unlike ``fetchCurrentOffering()``, this does not apply the legacy
    /// `ab_test_version` metadata selection — placements are the targeting
    /// mechanism. RevenueCat returns the placement's fallback offering when the
    /// placement is not explicitly configured, and `nil` when the placement
    /// explicitly excludes the user.
    ///
    /// - Parameters:
    ///    - placement: the RevenueCat placement identifier
    /// - Returns: the placement-targeted offering, or `nil` if none applies
    static func fetchCurrentOffering(forPlacement placement: String) async throws -> KOffering? {
        guard shared.kovaleeManager != nil else {
            throw PurchaseError.initializationProblem
        }
        guard Purchases.isConfigured else {
            throw PurchaseError.rcNotYetInitialized
        }

        KLogger.debug("🛍️ Fetching current offering for placement \"\(placement)\"...")

        let offerings = try await Purchases.shared.offerings()
        guard let offering = offerings.currentOffering(forPlacement: placement) else {
            KLogger.debug("🛍️ No offering available for placement \"\(placement)\"")
            return nil
        }

        KLogger.debug("🛍️ Fetched offering \(offering.identifier) for placement \"\(placement)\"")
        return KOffering(offering: offering)
    }

    /// Fetch the current ``Offering`` for a RevenueCat targeting placement.
    ///
    /// - Parameters:
    ///    - placement: the RevenueCat placement identifier
    ///    - completion: the placement-targeted offering, or `nil` if none applies
    static func fetchCurrentOffering(
        forPlacement placement: String,
        withCompletion completion: @escaping @Sendable (Result<KOffering?, Error>) -> Void
    ) {
        let placementCopy = placement // Create local copy
        Task { @Sendable in
            do {
                let result = try await Self.fetchCurrentOffering(forPlacement: placementCopy)
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                let capturedError = error // Capture error locally
                DispatchQueue.main.async {
                    completion(Result.failure(capturedError))
                }
            }
        }
    }

    /// Restore purchase previously made by current user
    ///
    /// - Parameters:
    ///    - fromSource: from where is the user making the purchase
    /// - Returns: current ``CustomerInfo``
    static func restorePurchases(fromSource source: String) async throws -> KCustomerInfo? {
        try await shared.kovaleeManager?.restorePurchases(fromSource: source) as? KCustomerInfo
    }

    /// Restore purchase previously made by current user
    ///
    /// - Parameters:
    ///    - fromSource: from where is the user making the purchase
    ///    - completion: current ``CustomerInfo``
    static func restorePurchases(
        fromSource source: String,
        withCompletion completion: @escaping @Sendable (Result<KCustomerInfo?, Error>) -> Void
    ) {
        let sourceCopy = source // Create local copy
        Task { @Sendable in
            do {
                let result = try await Self.restorePurchases(fromSource: sourceCopy)
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                let capturedError = error // Capture error locally
                DispatchQueue.main.async {
                    completion(Result.failure(capturedError))
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
    static func purchase(package: KPackage, fromSource source: String) async throws -> KPurchaseResultData? {
        try await shared.kovaleeManager?.purchase(package: package, fromSource: source) as? KPurchaseResultData
    }

    /// Performs a purchase of the specified ``Package``
    ///
    /// - Parameters:
    ///    - package: the package to be purchased
    ///    - fromSource: from where is the user making the purchase
    ///    - completion: the result of the purchase transaction as ``PurchaseResultData``
    static func purchase(
        package: KPackage,
        fromSource source: String,
        withCompletion completion: @escaping @Sendable (Result<KPurchaseResultData?, Error>) -> Void
    ) {
        // Create local copies to avoid capturing mutable state
        let packageCopy = package
        let sourceCopy = source

        Task { @Sendable in
            do {
                let result = try await Self.purchase(
                    package: packageCopy,
                    fromSource: sourceCopy
                )
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                let capturedError = error // Capture error locally
                DispatchQueue.main.async {
                    completion(Result.failure(capturedError))
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
    ) async throws -> KPurchaseResultData? {
        guard
            let offerings = try await shared.kovaleeManager?.fetchOfferings() as? KOfferings,
            let package = offerings.returnOffering(withSubscriptionId: subscriptionId)
        else {
            return nil
        }

        return try await Self.shared.kovaleeManager?.purchase(package: package, fromSource: source) as? KPurchaseResultData
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
        withCompletion completion: @escaping @Sendable (Result<KPurchaseResultData?, Error>) -> Void
    ) {
        // Create local copies
        let subscriptionIdCopy = subscriptionId
        let sourceCopy = source

        Task { @Sendable in
            do {
                let result = try await Self.purchaseSubscription(
                    withId: subscriptionIdCopy,
                    fromSource: sourceCopy
                )
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                let capturedError = error // Capture error locally
                DispatchQueue.main.async {
                    completion(Result.failure(capturedError))
                }
            }
        }
    }

    static func revenueCatUserId() -> String {
        shared.kovaleeManager?.revenueCatUserId() ?? ""
    }

    static func checkTrialOrIntroDiscountEligibility(productIdentifiers: [String]) async -> [String: KIntroEligibilityStatus] {
        await shared.kovaleeManager?
            .checkTrialOrIntroDiscountEligibility(productIdentifiers: productIdentifiers)?
            .compactMapValues { KIntroEligibilityStatus(rawValue: $0) } ?? [:]
    }

    static func checkTrialOrIntroDiscountEligibility(
        productIdentifiers: [String],
        withCompletion completion: @escaping @Sendable ([String: KIntroEligibilityStatus]) -> Void
    ) async {
        Task {
            completion(await Self.checkTrialOrIntroDiscountEligibility(productIdentifiers: productIdentifiers))
        }
    }

    static func setPurchasesDelegate(_ delegate: KovaleePurchasesDelegate) {
        shared.kovaleeManager?.setPurchaseDelegate(delegate)
    }
}

/// How fresh ``Kovalee/customerInfo(fetchPolicy:)`` requires its customer info to be.
public enum KCustomerInfoFetchPolicy: Sendable {
    /// Returns cached data if available (even if stale), otherwise fetches. RevenueCat's default,
    /// and the behavior of the no-argument ``Kovalee/customerInfo()``.
    case cachedOrFetched

    /// Always fetches up-to-date data, and fails rather than returning stale data.
    case fetchCurrent
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
