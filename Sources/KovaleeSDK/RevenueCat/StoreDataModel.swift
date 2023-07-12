import Foundation
import KovaleeFramework
import RevenueCat

// swiftlint:disable file_length
/// A container for the most recent customer info
public class CustomerInfo: AbstractCustomerInfo {

    /// ``EntitlementInfos`` attached to this customer info.
    public let entitlements: EntitlementInfos

    /// All *subscription* product identifiers with expiration dates in the future.
    public var activeSubscriptions: Set<String>

    /// All product identifiers purchases by the user regardless of expiration.
    public let allPurchasedProductIdentifiers: Set<String>

    /// Returns the latest expiration date of all products, nil if there are none.
    public var latestExpirationDate: Date?

    /// Returns all the non-subscription purchases a user has made.
    public let nonSubscriptions: [NonSubscriptionTransaction]

    /// Returns the fetch date of this CustomerInfo.
    public let requestDate: Date

    /// The date this user was first seen in RevenueCat.
    public let firstSeen: Date

    /// The original App User Id recorded for this user.
    public let originalAppUserId: String

    /**
     URL to manage the active subscription of the user.
     * If this user has an active iOS subscription, this will point to the App Store.
     * If the user has an active Play Store subscription it will point there.
     * If there are no active subscriptions it will be null.
     * If there are multiple for different platforms, it will point to the App Store.
     */
    public let managementURL: URL?

    /**
     * Returns the purchase date for the version of the application when the user bought the app.
     * Use this for grandfathering users when migrating to subscriptions.
     */
    public let originalPurchaseDate: Date?

    init(info: RevenueCat.CustomerInfo) {
        self.entitlements = EntitlementInfos(entitlements: info.entitlements)
        self.activeSubscriptions = info.activeSubscriptions
        self.allPurchasedProductIdentifiers = info.allPurchasedProductIdentifiers
        self.latestExpirationDate = info.latestExpirationDate
        self.nonSubscriptions = info.nonSubscriptions.map { NonSubscriptionTransaction(transaction: $0) }
        self.requestDate = info.requestDate
        self.firstSeen = info.firstSeen
        self.originalAppUserId = info.originalAppUserId
        self.managementURL = info.managementURL
        self.originalPurchaseDate = info.originalPurchaseDate
    }
}

/// This class contains all the entitlements associated to the user.
public class EntitlementInfos: NSObject {

    /**
     Dictionary of all EntitlementInfo (``EntitlementInfo``) objects (active and inactive) keyed by entitlement
     identifier. This dictionary can also be accessed by using an index subscript on ``EntitlementInfos``, e.g.
     `entitlementInfos["pro_entitlement_id"]`.
     */
    public let all: [String: EntitlementInfo]

    public subscript(key: String) -> EntitlementInfo? {
        return self.all[key]
    }

    init(entitlements: RevenueCat.EntitlementInfos) {
        self.all = entitlements.all.reduce(into: [String: EntitlementInfo]()) { all, entitlement in
            all[entitlement.key] = EntitlementInfo(info: entitlement.value)
        }
    }
}

///  The EntitlementInfo object gives you access to all of the information about the status of a user entitlement.
public class EntitlementInfo: NSObject {

    /// The entitlement identifier configured in the RevenueCat dashboard
    public var identifier: String

    ///  True if the user has access to this entitlement
    public var isActive: Bool

    /// True if the underlying subscription is set to renew at the end of the billing period (``expirationDate``).
    public var willRenew: Bool

    /// The last period type this entitlement was in
    public var periodType: PeriodType

    /// The latest purchase or renewal date for the entitlement.
    public var latestPurchaseDate: Date?

    /// The first date this entitlement was purchased
    public var originalPurchaseDate: Date?

    /// The expiration date for the entitlement, can be `nil` for lifetime access.
     /// If the ``periodType`` is ``PeriodType/trial``, this is the trial expiration date.
    public var expirationDate: Date?

    /// The store where this entitlement was unlocked from
    public var store: Store

    /// The product identifier that unlocked this entitlement
    public var productIdentifier: String

    /// False if this entitlement is unlocked via a production purchase
    public var isSandbox: Bool

    /// The date an unsubscribe was detected. Can be `nil`.
    /// - Note: Entitlement may still be active even if user has unsubscribed. Check the ``isActive`` property.
    public var unsubscribeDetectedAt: Date?

    /// The date a billing issue was detected. Can be `nil` if there is no billing issue or an issue has been resolved.
    /// - Note: Entitlement may still be active even if there is a billing issue.
    public var billingIssueDetectedAt: Date?

    /**
     Use this property to determine whether a purchase was made by the current user
     or shared to them by a family member. This can be useful for onboarding users who have had
     an entitlement shared with them, but might not be entirely aware of the benefits they now have.
     */
    public var ownershipType: PurchaseOwnershipType

    init(info: RevenueCat.EntitlementInfo) {
        self.identifier = info.identifier
        self.isActive = info.isActive
        self.willRenew = info.willRenew
        self.periodType = PeriodType(rawValue: info.periodType.rawValue)!
        self.latestPurchaseDate = info.latestPurchaseDate
        self.originalPurchaseDate = info.originalPurchaseDate
        self.expirationDate = info.expirationDate
        self.store = Store(rawValue: info.store.rawValue)!
        self.productIdentifier = info.productIdentifier
        self.isSandbox = info.isSandbox
        self.unsubscribeDetectedAt = info.unsubscribeDetectedAt
        self.billingIssueDetectedAt = info.billingIssueDetectedAt
        self.ownershipType = PurchaseOwnershipType(rawValue: info.ownershipType.rawValue)!
    }
}

/// Information that represents a non-subscription purchase made by a user.
public class NonSubscriptionTransaction: NSObject {

    /// The product identifier.
    public let productIdentifier: String

    /// The date that App Store charged the user’s account.
    public let purchaseDate: Date

    /// The unique identifier for the transaction.
    public let transactionIdentifier: String

    init(transaction: RevenueCat.NonSubscriptionTransaction) {
        self.productIdentifier = transaction.productIdentifier
        self.purchaseDate = transaction.purchaseDate
        self.transactionIdentifier = transaction.transactionIdentifier
    }
}

public enum PeriodType: Int {
    /// If the entitlement is not under an introductory or trial period.
    case normal = 0

    /// If the entitlement is under a introductory price period.
    case intro = 1

    /// If the entitlement is under a trial period.
    case trial = 2
}

public enum PurchaseOwnershipType: Int {
    case purchased = 0
    case familyShared = 1
    case unknown = 2
}

public enum Store: Int {
    /// For entitlements granted via Apple App Store.
    case appStore = 0
    /// For entitlements granted via Apple Mac App Store.
    case macAppStore = 1

    /// For entitlements granted via Google Play Store.
    case playStore = 2

    /// For entitlements granted via Stripe
    case stripe = 3

    /// For entitlements granted via a promo in RevenueCat.
    case promotional = 4

    /// For entitlements granted via an unknown store.
    case unknownStore = 5

    /// For entitlements granted via the Amazon Store.
    case amazon = 6
}

public class Product {
    var identifier: String
    var isActive: Bool
    var willRenew: Bool

    var latestPurchaseDate: Date?
    var originalPurchaseDate: Date?
    var expirationDate: Date?

    var productIdentifier: String
    var isSandbox: Bool
    var unsubscribeDetectedAt: Date?
    var billingIssueDetectedAt: Date?

    init(entitlement: RevenueCat.EntitlementInfo) {
        self.identifier = entitlement.identifier
        self.isActive = entitlement.isActive
        self.willRenew = entitlement.willRenew
        self.latestPurchaseDate = entitlement.latestPurchaseDate
        self.originalPurchaseDate = entitlement.originalPurchaseDate
        self.expirationDate = entitlement.expirationDate
        self.productIdentifier = entitlement.productIdentifier
        self.isSandbox = entitlement.isSandbox
        self.unsubscribeDetectedAt = entitlement.unsubscribeDetectedAt
        self.billingIssueDetectedAt = entitlement.billingIssueDetectedAt
    }
}

public struct Offerings: AbstractOfferings {
    public let all: [String: Offering]
    public var current: Offering?

    init(_ offerings: RevenueCat.Offerings) {
        self.all = offerings.all.reduce(into: [String: Offering]()) { all, offering in
                all[offering.key] = Offering(offering: offering.value)
            }
        self.current = offerings.current != nil ? Offering(offering: offerings.current!) : nil
    }
}

/// An offering is a collection of ``Package``s, and they let you control which products
/// are shown to users without requiring an app update.
public class Offering: AbstractOffering {

    /// Unique identifier defined in RevenueCat dashboard.
    public let identifier: String

    /// Offering description defined in RevenueCat dashboard.
    public let serverDescription: String

    /// Array of ``Package`` objects available for purchase.
    public let availablePackages: [Package]

    /// Lifetime ``Package`` type configured in the RevenueCat dashboard, if available.
    public let lifetime: Package?

    /// Annual ``Package`` type configured in the RevenueCat dashboard, if available.
    public let annual: Package?

    /// Six month ``Package`` type configured in the RevenueCat dashboard, if available.
    public let sixMonth: Package?

    /// Three month ``Package`` type configured in the RevenueCat dashboard, if available.
    public let threeMonth: Package?

    /// Two month ``Package`` type configured in the RevenueCat dashboard, if available.
    public let twoMonth: Package?

    /// Monthly ``Package`` type configured in the RevenueCat dashboard, if available.
    public let monthly: Package?

    /// Weekly ``Package`` type configured in the RevenueCat dashboard, if available.
    public let weekly: Package?

    init(offering: RevenueCat.Offering) {
        self.identifier = offering.identifier
        self.serverDescription = offering.serverDescription
        self.availablePackages = offering.availablePackages.compactMap { Package(package: $0) }
        self.lifetime = Package(package: offering.lifetime)
        self.annual = Package(package: offering.annual)
        self.sixMonth = Package(package: offering.sixMonth)
        self.threeMonth = Package(package: offering.threeMonth)
        self.twoMonth = Package(package: offering.twoMonth)
        self.monthly = Package(package: offering.monthly)
        self.weekly = Package(package: offering.weekly)
    }
}

/// Packages help abstract platform-specific products by grouping equivalent products across iOS, Android, and web.
/// A package is made up of three parts: ``identifier``, ``packageType``, and underlying ``StoreProduct``.
public class Package: Identifiable, AbstractPackage {
    public var id: String {
        identifier
    }

	public var productIdentifier: String {
		storeProduct.productIdentifier
	}
	
    /// The identifier for this Package.
    public let identifier: String

    /// The type configured for this package.
    public let packageType: PackageType

    /// The underlying ``storeProduct``
    public let storeProduct: StoreProduct

    /// The identifier of the ``Offering`` containing this Package.
    public let offeringIdentifier: String

    /// The price of this product using ``StoreProduct/priceFormatter``.
    public var localizedPriceString: String

    /// The price of the ``StoreProduct/introductoryDiscount`` formatted using ``StoreProduct/priceFormatter``.
    /// - Returns: `nil` if there is no `introductoryDiscount`.
    public var localizedIntroductoryPriceString: String?

    public var rcPackage: Any

    init?(package: RevenueCat.Package?) {
        guard let package else {
            return nil
        }
        self.identifier = package.identifier
        self.packageType = PackageType(rawValue: package.packageType.rawValue) ?? .unknown
        self.storeProduct = StoreProduct(package.storeProduct)
        self.offeringIdentifier = package.offeringIdentifier
        self.localizedPriceString = package.localizedPriceString
        self.localizedIntroductoryPriceString = package.localizedIntroductoryPriceString
        self.rcPackage = package
    }
	
	internal required init() {
		self.identifier = "0"
		self.packageType = .unknown
		self.storeProduct = StoreProduct.empty()
		self.offeringIdentifier = ""
		self.localizedPriceString = ""
		self.localizedIntroductoryPriceString = nil
		self.rcPackage = false
	}

	/// Generates an empty Package
	/// To use only for testing purposes
	static public func empty() -> Package {
		self.init()
	}
	
    public func getDuration() -> Int {
		guard let subscriptionPeriod = (self.rcPackage as! RevenueCat.Package).storeProduct.subscriptionPeriod else {
            return 0
        }

        switch subscriptionPeriod.unit {
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

/// Type that provides access to all of `StoreKit`'s product type's properties.
public struct StoreProduct {
	
	/// The type of product.
	public var productType: ProductType
	
	/// The category of this product, whether a subscription or a one-time purchase.
	public var productCategory: ProductCategory
	
	/// A description of the product.
	/// - Note: The title's language is determined by the storefront that the user's device is connected to,
	/// not the preferred language set on the device.
	public var localizedDescription: String
	
	/// The name of the product.
	public var localizedTitle: String
	
	/// The currency of the product's price.
	public var currencyCode: String?
	
	/// The decimal representation of the cost of the product, in local currency.
	public var price: Decimal
	
	/// The price of this product using ``priceFormatter``.
	public var localizedPriceString: String
	
	/// The string that identifies the product to the Apple App Store.
	public var productIdentifier: String
	
	/// A Boolean value that indicates whether the product is available for family sharing in App Store Connect.
	/// Check the value of `isFamilyShareable` to learn whether an in-app purchase is sharable with the family group.
	///
	/// When displaying in-app purchases in your app, indicate whether the product includes Family Sharing
	/// to help customers make a selection that best fits their needs.
	///
	/// Configure your in-app purchases to allow Family Sharing in App Store Connect.
	/// For more information about setting up Family Sharing, see Turn-on Family Sharing for in-app purchases.
	public var isFamilyShareable: Bool
	
	/// The identifier of the subscription group to which the subscription belongs.
	/// All auto-renewable subscriptions must be a part of a group.
	/// You create the group identifiers in App Store Connect.
	/// This property is `nil` if the product is not an auto-renewable subscription.
	public var subscriptionGroupIdentifier: String?
	
	/// Provides a `NumberFormatter`, useful for formatting the price for displaying.
	/// - Note: This creates a new formatter for every product, which can be slow.
	/// - Returns: `nil` for StoreKit 2 backed products if the currency code could not be determined.
	public var priceFormatter: NumberFormatter?
	
	/// The period details for products that are subscriptions.
	/// - Returns: `nil` if the product is not a subscription.
	public var subscriptionPeriod: SubscriptionPeriod?
	
	/// The object containing introductory price information for the product.
	/// If you've set up introductory prices in App Store Connect, the introductory price property will be populated.
	/// This property is `nil` if the product has no introductory price.
	///
	/// Before displaying UI that offers the introductory price,
	/// you must first determine if the user is eligible to receive it.
	public var introductoryDiscount: StoreProductDiscount?
	
	/// An array of subscription offers available for the auto-renewable subscription.
	/// - Note: the current user may or may not be eligible for some of these.
	public var discounts: [StoreProductDiscount]
	
	init(_ product: RevenueCat.StoreProduct) {
		self.productType = ProductType(rawValue: product.productType.rawValue)!
		self.productCategory = ProductCategory(rawValue: product.productCategory.rawValue)!
		self.localizedDescription = product.localizedDescription
		self.localizedTitle = product.localizedTitle
		self.currencyCode = product.currencyCode
		self.price = product.price
		self.localizedPriceString = product.localizedPriceString
		self.productIdentifier = product.productIdentifier
		self.isFamilyShareable = product.isFamilyShareable
		self.subscriptionGroupIdentifier = product.subscriptionGroupIdentifier
		self.priceFormatter = product.priceFormatter
		self.subscriptionPeriod = product.subscriptionPeriod != nil ?
		SubscriptionPeriod(product.subscriptionPeriod!) : nil
		self.introductoryDiscount = StoreProductDiscount(product.introductoryDiscount)
		self.discounts = product.discounts.compactMap { StoreProductDiscount($0) }
	}
	
	private init() {
		self.productType = .consumable
		self.productCategory = .subscription
		self.localizedDescription = ""
		self.localizedTitle = ""
		self.currencyCode = nil
		self.price = 0
		self.localizedPriceString = ""
		self.productIdentifier = ""
		self.isFamilyShareable = false
		self.subscriptionGroupIdentifier = nil
		self.priceFormatter = nil
		self.subscriptionPeriod = nil
		self.introductoryDiscount = nil
		self.discounts = []
	}
	
	static func empty() -> Self {
		self.init()
	}
}

public enum ProductCategory: Int {
    /// A non-renewable or auto-renewable subscription.
    case subscription
    /// A consumable or non-consumable in-app purchase.
    case nonSubscription
}

public enum ProductType: Int {
    /// A consumable in-app purchase.
    case consumable
    /// A non-consumable in-app purchase.
    case nonConsumable
    /// A non-renewing subscription.
    case nonRenewableSubscription
    /// An auto-renewable subscription.
    case autoRenewableSubscription
}

public struct SubscriptionPeriod {
    /// The number of period units.
    public let value: Int
    /// The increment of time that a subscription period is specified in.
    public let unit: Unit

    public enum Unit: Int {
        /// A subscription period unit of a day.
        case day = 0
        /// A subscription period unit of a week.
        case week = 1
        /// A subscription period unit of a month.
        case month = 2
        /// A subscription period unit of a year.
        case year = 3
    }

    init(_ period: RevenueCat.SubscriptionPeriod) {
        self.value = period.value
        self.unit = Unit(rawValue: period.unit.rawValue)!
    }
}

public struct StoreProductDiscount {
    public enum PaymentMode: Int {

        /// Price is charged one or more times
        case payAsYouGo = 0
        /// Price is charged once in advance
        case payUpFront = 1
        /// No initial charge
        case freeTrial = 2

    }

    public enum DiscountType: Int {
        /// Introductory offer
        case introductory = 0
        /// Promotional offer for subscriptions
        case promotional = 1
    }

    public var offerIdentifier: String?
    public var currencyCode: String?
    public var price: Decimal
    public var localizedPriceString: String
    public var paymentMode: PaymentMode
    public var subscriptionPeriod: SubscriptionPeriod
    public var numberOfPeriods: Int
    public var type: DiscountType

    init?(_ discount: RevenueCat.StoreProductDiscount?) {
        guard let discount else {
            return nil
        }

        self.offerIdentifier = discount.offerIdentifier
        self.currencyCode = discount.currencyCode
        self.price = discount.price
        self.localizedPriceString = discount.localizedPriceString
        self.paymentMode = PaymentMode(rawValue: discount.paymentMode.rawValue)!
        self.subscriptionPeriod = SubscriptionPeriod(discount.subscriptionPeriod)
        self.numberOfPeriods = discount.numberOfPeriods
        self.type = DiscountType(rawValue: discount.type.rawValue)!
    }
}

public enum PackageType: Int {

    /// A package that was defined with an unknown identifier.
    case unknown = -2,
    /// A package that was defined with a custom identifier.
    custom,
    /// A package configured with the predefined lifetime identifier.
    lifetime,
    /// A package configured with the predefined annual identifier.
    annual,
    /// A package configured with the predefined six month identifier.
    sixMonth,
    /// A package configured with the predefined three month identifier.
    threeMonth,
    /// A package configured with the predefined two month identifier.
    twoMonth,
    /// A package configured with the predefined monthly identifier.
    monthly,
    /// A package configured with the predefined weekly identifier.
    weekly
}

public struct StoreTransaction {
    public var productIdentifier: String
    public var purchaseDate: Date
    public var transactionIdentifier: String
    public var quantity: Int

    init?(transaction: RevenueCat.StoreTransaction?) {
        guard let transaction else {
            return nil
        }
        self.productIdentifier = transaction.productIdentifier
        self.purchaseDate = transaction.purchaseDate
        self.transactionIdentifier = transaction.transactionIdentifier
        self.quantity = transaction.quantity
    }
}

public struct PurchaseResultData: AbstractPurchaseResultData {
    public var transaction: StoreTransaction?
    public var customerInfo: CustomerInfo
    public var userCancelled: Bool
}
// swiftlint:enable file_length
