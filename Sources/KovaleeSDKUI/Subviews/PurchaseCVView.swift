import KovaleeFramework
import KovaleePurchases
import KovaleeSDK
import SwiftUI

@available(iOS 16.0, *)
struct PurchaseCVView: View {
    @State private var customerInfo: KCustomerInfo?
    @State private var revenueCatUserId: String?

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        Group {
            if let revenueCatUserId {
                InfoLabel(
                    title: "RevenueCat User ID:",
                    value: revenueCatUserId,
                    horizontal: false,
                    allowCopy: true
                )
            }

            if let info = customerInfo {
                InfoLabel(
                    title: "Original App User ID:",
                    value: info.originalAppUserId,
                    horizontal: false,
                    allowCopy: true
                )

                premiumStatusRow(info: info)

                if info.activeSubscriptions.isEmpty {
                    Text("No active subscriptions")
                        .foregroundStyle(.secondary)
                } else {
                    activeSubscriptionsSection(info: info)
                }

                if info.activeEntitlements {
                    entitlementsSection(info: info)
                }

                datesSection(info: info)

                if !info.allPurchasedProductIdentifiers.isEmpty {
                    allPurchasesSection(info: info)
                }

                if !info.nonSubscriptions.isEmpty {
                    nonSubscriptionsSection(info: info)
                }

                if let managementURL = info.managementURL {
                    InfoLabel(
                        title: "Management URL:",
                        value: managementURL.absoluteString,
                        horizontal: false,
                        allowCopy: true
                    )
                }
            } else {
                Text("No purchase info available")
                    .foregroundStyle(.secondary)
            }
        }
        .task {
            self.customerInfo = try? await Kovalee.customerInfo()
            self.revenueCatUserId = Kovalee.revenueCatUserId()
        }
    }

    @ViewBuilder
    private func premiumStatusRow(info: KCustomerInfo) -> some View {
        let isPremium = !info.activeSubscriptions.isEmpty || info.activeEntitlements
        InfoLabel(
            title: "Premium:",
            value: isPremium ? "Yes" : "No"
        )
    }

    @ViewBuilder
    private func activeSubscriptionsSection(info: KCustomerInfo) -> some View {
        Text("Active Subscriptions:").bold()
        ForEach(Array(info.activeSubscriptions).sorted(), id: \.self) { subscription in
            Text(subscription)
                .font(.footnote)
                .monospaced()
        }
        if let expirationDate = info.latestExpirationDate {
            InfoLabel(
                title: "Latest Expiration:",
                value: dateFormatter.string(from: expirationDate)
            )
        }
    }

    @ViewBuilder
    private func entitlementsSection(info: KCustomerInfo) -> some View {
        Text("Active Entitlements:").bold()
        ForEach(
            Array(info.entitlements.active.values).sorted(by: { $0.identifier < $1.identifier }),
            id: \.identifier
        ) { entitlement in
            VStack(alignment: .leading, spacing: 2) {
                Text(entitlement.identifier)
                    .font(.footnote)
                    .monospaced()
                    .bold()
                Group {
                    Text("Product: \(entitlement.productIdentifier)")
                    Text("Will Renew: \(entitlement.willRenew ? "Yes" : "No")")
                    if let periodType = entitlement.periodType {
                        Text("Period: \(periodTypeLabel(periodType))")
                    }
                    if entitlement.isSandbox {
                        Text("Sandbox")
                            .foregroundStyle(.orange)
                    }
                    Text("Ownership: \(ownershipLabel(entitlement.ownershipType))")
                    if let expiration = entitlement.expirationDate {
                        Text("Expires: \(dateFormatter.string(from: expiration))")
                    }
                    if let billing = entitlement.billingIssueDetectedAt {
                        Text("Billing Issue: \(dateFormatter.string(from: billing))")
                            .foregroundStyle(.red)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 2)
        }
    }

    @ViewBuilder
    private func datesSection(info: KCustomerInfo) -> some View {
        InfoLabel(
            title: "First Seen:",
            value: dateFormatter.string(from: info.firstSeen)
        )
        if let originalPurchaseDate = info.originalPurchaseDate {
            InfoLabel(
                title: "Original Purchase:",
                value: dateFormatter.string(from: originalPurchaseDate)
            )
        }
    }

    @ViewBuilder
    private func allPurchasesSection(info: KCustomerInfo) -> some View {
        DisclosureGroup("All Purchased Products (\(info.allPurchasedProductIdentifiers.count))") {
            ForEach(Array(info.allPurchasedProductIdentifiers).sorted(), id: \.self) { product in
                Text(product)
                    .font(.footnote)
                    .monospaced()
            }
        }
    }

    @ViewBuilder
    private func nonSubscriptionsSection(info: KCustomerInfo) -> some View {
        DisclosureGroup("Non-Subscription Purchases (\(info.nonSubscriptions.count))") {
            ForEach(info.nonSubscriptions, id: \.transactionIdentifier) { transaction in
                VStack(alignment: .leading, spacing: 2) {
                    Text(transaction.productIdentifier)
                        .font(.footnote)
                        .monospaced()
                    Text("Date: \(dateFormatter.string(from: transaction.purchaseDate))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func periodTypeLabel(_ type: KPeriodType) -> String {
        switch type {
        case .normal: return "Normal"
        case .intro: return "Intro"
        case .trial: return "Trial"
        }
    }

    private func ownershipLabel(_ type: KPurchaseOwnershipType) -> String {
        switch type {
        case .purchased: return "Purchased"
        case .familyShared: return "Family Shared"
        case .unknown: return "Unknown"
        }
    }
}
