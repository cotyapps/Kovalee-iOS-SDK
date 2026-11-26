import Foundation
import KovaleeSDK
import RevenueCat
import Security

/// Debug and TestFlight builds only: the App Store test purchases a tester chose to
/// ignore, so the app treats them as not bought and the paywall can be tested again.
///
/// A TestFlight purchase is made with the tester's real Apple Account, so it can't be
/// wiped: clearing a Sandbox account's history doesn't touch it, deleting the
/// RevenueCat customer doesn't either (RevenueCat gives it back to the next user),
/// TestFlight renews a subscription every day up to 6 times, and a lifetime purchase
/// never ends. Ignoring it is the way back to a free user, a lifetime purchase included.
///
/// ## Safety
/// Ignoring can only take premium away, never grant it, and it never touches a real
/// purchase: only a purchase RevenueCat reports as an **App Store sandbox** purchase
/// (`store == .appStore` and `isSandbox`) is ever ignored. App Store customers only
/// have production purchases, so a paying customer stays premium even if the build
/// check below were wrong. On top of that, the list is only read in debug and
/// TestFlight builds.
///
/// ## Entitlements
/// RevenueCat names one product per entitlement, so an entitlement is only switched
/// off when its product is ignored **and** no other active purchase that isn't
/// ignored is left: with a weekly and a lifetime both granting `premium`, ignoring
/// the lifetime keeps `premium` active. If a different purchase is left, the tester
/// stays premium: when in doubt, a tester can stay premium but is never made free.
///
/// ## Lifecycle
/// Purchases are ignored by product id, which stays the same across TestFlight's daily
/// renewals. Buying the product again stops ignoring it, restoring purchases stops
/// ignoring them all, and so does the badge the paywall shows while some are ignored.
/// The list is kept in the Keychain, so it survives a reinstall.
///
/// ``KCustomerInfo`` (and so `Kovalee.customerInfo()` and `Kovalee.isUserPremium()`)
/// leaves ignored purchases out of its entitlements, active subscriptions,
/// non-subscription purchases, purchased product ids and latest expiration date. Apps
/// that read RevenueCat directly use ``isPremium(_:)``,
/// ``ignores(_:in:)`` or ``ignores(_:)``.
public enum IgnoredTestPurchases {
    /// Posted on the main thread when the ignored purchases change, and when the debug
    /// console closes after changing test purchases (a refund, a new RevenueCat user).
    /// Apps that keep premium status in memory refresh it.
    public static let didChangeNotification = Notification.Name("KovaleeIgnoredTestPurchasesDidChange")

    /// Whether this build can ignore test purchases: debug and TestFlight builds.
    public static var isAvailable: Bool {
        #if DEBUG
            return true
        #else
            return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        #endif
    }

    /// The product ids whose App Store sandbox purchases are ignored. Always empty
    /// outside debug and TestFlight builds.
    public static var productIDs: Set<String> {
        isAvailable ? storage.productIDs : []
    }

    /// Ignores this product's App Store sandbox purchases, or stops ignoring them.
    /// Does nothing outside debug and TestFlight builds.
    public static func setIgnoring(_ ignores: Bool, productID: String) {
        setIgnoring(ignores, productID: productID, notifies: true)
    }

    /// Stops ignoring every purchase.
    /// - Returns: whether some purchase was ignored.
    @discardableResult
    public static func stopIgnoringAll() -> Bool {
        stopIgnoringAll(notifies: true)
    }

    /// Whether this active entitlement is switched off: its product is an ignored test
    /// purchase and no other active purchase that isn't ignored is left. `false` for
    /// every production purchase.
    public static func ignores(_ entitlement: EntitlementInfo, in customerInfo: CustomerInfo) -> Bool {
        ignores(entitlement, in: customerInfo, ignoring: productIDs)
    }

    /// Whether this subscription is an ignored test purchase. `false` for every
    /// production purchase.
    public static func ignores(_ subscription: SubscriptionInfo) -> Bool {
        ignores(subscription, ignoring: productIDs)
    }

    /// The premium rule of `Kovalee.isUserPremium()` (an active subscription or
    /// entitlement), with ignored test purchases left out. For apps that read
    /// RevenueCat's `CustomerInfo` directly.
    public static func isPremium(_ customerInfo: CustomerInfo) -> Bool {
        isPremium(customerInfo, ignoring: productIDs)
    }

    // MARK: - Internal

    /// The rule, in one place: only an App Store sandbox purchase of a listed product
    /// is ignored.
    static func ignores(
        productID: String,
        isSandbox: Bool,
        isAppStore: Bool,
        ignoredProductIDs: Set<String> = productIDs
    ) -> Bool {
        isSandbox && isAppStore && ignoredProductIDs.contains(productID)
    }

    static func ignores(_ subscription: SubscriptionInfo, ignoring ignoredProductIDs: Set<String>) -> Bool {
        ignores(
            productID: subscription.productIdentifier,
            isSandbox: subscription.isSandbox,
            isAppStore: subscription.store == .appStore,
            ignoredProductIDs: ignoredProductIDs
        )
    }

    static func ignores(_ transaction: NonSubscriptionTransaction, ignoring ignoredProductIDs: Set<String>) -> Bool {
        ignores(
            productID: transaction.productIdentifier,
            isSandbox: transaction.isSandbox,
            isAppStore: transaction.store == .appStore,
            ignoredProductIDs: ignoredProductIDs
        )
    }

    /// Whether an active subscription is ignored. One RevenueCat doesn't describe
    /// can't be shown to be a sandbox purchase, so it counts.
    static func ignoresSubscription(
        _ productID: String,
        in customerInfo: CustomerInfo,
        ignoring ignoredProductIDs: Set<String>
    ) -> Bool {
        guard let subscription = customerInfo.subscriptionsByProductIdentifier[productID] else {
            return false
        }
        return ignores(subscription, ignoring: ignoredProductIDs)
    }

    /// Whether a product the customer bought is an ignored test purchase, as RevenueCat
    /// describes it (a subscription or a non-subscription purchase).
    static func ignoresProduct(
        _ productID: String,
        in customerInfo: CustomerInfo,
        ignoring ignoredProductIDs: Set<String>
    ) -> Bool {
        if let subscription = customerInfo.subscriptionsByProductIdentifier[productID] {
            return ignores(subscription, ignoring: ignoredProductIDs)
        }
        let transactions = customerInfo.nonSubscriptions.filter { $0.productIdentifier == productID }
        return !transactions.isEmpty && transactions.allSatisfy { ignores($0, ignoring: ignoredProductIDs) }
    }

    /// Whether some active purchase isn't ignored: an active subscription or a
    /// non-subscription purchase.
    static func hasPurchaseNotIgnored(_ customerInfo: CustomerInfo, ignoring ignoredProductIDs: Set<String>) -> Bool {
        customerInfo.activeSubscriptions.contains {
            !ignoresSubscription($0, in: customerInfo, ignoring: ignoredProductIDs)
        } || customerInfo.nonSubscriptions.contains { !ignores($0, ignoring: ignoredProductIDs) }
    }

    static func ignores(
        _ entitlement: EntitlementInfo,
        in customerInfo: CustomerInfo,
        ignoring ignoredProductIDs: Set<String>
    ) -> Bool {
        let fromIgnoredProduct = ignores(
            productID: entitlement.productIdentifier,
            isSandbox: entitlement.isSandbox,
            isAppStore: entitlement.store == .appStore,
            ignoredProductIDs: ignoredProductIDs
        )
        return fromIgnoredProduct && !hasPurchaseNotIgnored(customerInfo, ignoring: ignoredProductIDs)
    }

    static func isPremium(_ customerInfo: CustomerInfo, ignoring ignoredProductIDs: Set<String>) -> Bool {
        customerInfo.entitlements.active.values.contains {
            !ignores($0, in: customerInfo, ignoring: ignoredProductIDs)
        } || customerInfo.activeSubscriptions.contains {
            !ignoresSubscription($0, in: customerInfo, ignoring: ignoredProductIDs)
        }
    }

    /// Like ``setIgnoring(_:productID:)``. The debug console passes `notifies: false`
    /// and posts ``didChangeNotification`` once it closes, since the app can't
    /// present its paywall over it.
    @_spi(KovaleeDebug)
    public static func setIgnoring(_ ignores: Bool, productID: String, notifies: Bool) {
        guard isAvailable else { return }
        let changed = storage.update { ids in
            if ignores {
                ids.insert(productID)
            } else {
                ids.remove(productID)
            }
        }
        if changed { didChange(notifies: notifies) }
    }

    @discardableResult
    static func stopIgnoringAll(notifies: Bool) -> Bool {
        guard isAvailable else { return false }
        let changed = storage.update { $0.removeAll() }
        if changed { didChange(notifies: notifies) }
        return changed
    }

    static func postDidChange() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: didChangeNotification, object: nil)
        }
    }

    private static func didChange(notifies: Bool) {
        // TestFlight events go to the production Amplitude project: say which
        // purchases are ignored, so these testers' "not premium" can be told apart.
        let ids = storage.productIDs.sorted()
        Kovalee.setUserProperty(
            key: "ignored_test_purchases",
            value: ids.isEmpty ? "none" : ids.joined(separator: ",")
        )
        if notifies { postDidChange() }
    }

    private static let storage = IgnoredProductIDStorage(
        service: (Bundle.main.bundleIdentifier ?? "kovalee") + ".kovalee.ignored-test-purchases"
    )
}

/// Where the ignored product ids are kept.
protocol IgnoredProductIDStore: Sendable {
    /// The stored ids, `[]` when none are stored, `nil` when the store can't be read.
    func load() -> Set<String>?
    /// - Returns: whether the store now holds `ids`.
    func save(_ ids: Set<String>) -> Bool
}

/// The ignored product ids, cached in memory since every ``KCustomerInfo`` reads them.
///
/// A store error (for example the Keychain before the first unlock after a reboot) is
/// never taken for an empty list: nothing is cached, the next read tries again, the
/// stored list is never overwritten from a read that failed, and a failed save
/// changes nothing.
final class IgnoredProductIDStorage: @unchecked Sendable {
    private let store: IgnoredProductIDStore
    private let lock = NSLock()
    private var cache: Set<String>?

    init(store: IgnoredProductIDStore) {
        self.store = store
    }

    /// Kept in the Keychain, so the list survives a reinstall.
    convenience init(service: String) {
        self.init(store: KeychainIgnoredProductIDStore(service: service))
    }

    /// The stored ids, or none while the store can't be read.
    var productIDs: Set<String> {
        lock.lock()
        defer { lock.unlock() }
        return loadedProductIDs() ?? []
    }

    /// Applies `change` and saves the result.
    /// - Returns: whether the ids changed and were saved. `false` when the store
    ///   can't be read or written, so nothing changed.
    @discardableResult
    func update(_ change: (inout Set<String>) -> Void) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        guard var ids = loadedProductIDs() else { return false }
        let before = ids
        change(&ids)
        guard ids != before, store.save(ids) else { return false }
        cache = ids
        return true
    }

    private func loadedProductIDs() -> Set<String>? {
        if let cache { return cache }
        guard let loaded = store.load() else { return nil }
        cache = loaded
        return loaded
    }
}

/// A Keychain item only this device can read, kept after the app is deleted.
struct KeychainIgnoredProductIDStore: IgnoredProductIDStore {
    let service: String
    let account = "productIDs"

    private var itemQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
    }

    func load() -> Set<String>? {
        var query = itemQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: AnyObject?
        switch SecItemCopyMatching(query as CFDictionary, &result) {
        case errSecSuccess:
            guard let data = result as? Data,
                  let ids = try? JSONDecoder().decode([String].self, from: data)
            else { return [] }
            return Set(ids)
        case errSecItemNotFound:
            return []
        default:
            return nil
        }
    }

    func save(_ ids: Set<String>) -> Bool {
        guard !ids.isEmpty else {
            let status = SecItemDelete(itemQuery as CFDictionary)
            return status == errSecSuccess || status == errSecItemNotFound
        }
        guard let data = try? JSONEncoder().encode(ids.sorted()) else { return false }
        let status = SecItemUpdate(
            itemQuery as CFDictionary,
            [kSecValueData as String: data] as CFDictionary
        )
        guard status == errSecItemNotFound else { return status == errSecSuccess }
        var attributes = itemQuery
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        return SecItemAdd(attributes as CFDictionary, nil) == errSecSuccess
    }
}
