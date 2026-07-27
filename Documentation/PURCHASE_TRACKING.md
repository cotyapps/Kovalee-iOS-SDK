# Purchase Conversion Tracking

Every completed subscription purchase can fire **value-carrying conversion events** to the ad/analytics sinks in one consent-gated dispatch:

| Sink | Trial start (free trial) | Real charge | Value |
|------|--------------------------|-------------|-------|
| **TikTok** | `StartTrial` + `Subscribe` | `Subscribe` | yes |
| **Firebase** | — *(nothing — see below)* | GA4 standard `purchase` | yes (`value`, `currency`, `transaction_id`) |

**Why Firebase gets nothing on trial starts:** a free-trial start collects no money. Logging the recurring price would overstate GA4 revenue by one full price per trial and feed unrealized value to Google Ads bidding.

**Trials are detected at the transaction level.** A product *offering* a free trial is not enough: a lapsed, intro-ineligible re-subscriber pays full price immediately. When the StoreKit 2 transaction is available, the SDK requires that the transaction actually redeemed an introductory offer; without a transaction it falls back to the product-level check.

All conversions are gated by `Kovalee.setDataCollectionEnabled(_:)` — nothing fires while data collection is off.

---

## The one rule

> **A purchase must reach the conversion dispatch through exactly ONE of the paths below.** They all fan out to the same sinks; combining them double-counts revenue on every ad platform.

## Path 1 — native purchases (automatic)

`Kovalee.purchase(package:fromSource:)` and `Kovalee.purchaseSubscription(withId:fromSource:)` fire the conversions internally. If your paywall calls these, you are done — do **not** add any tracking call.

```swift
let result = try await Kovalee.purchase(package: package, fromSource: "onboarding")
```

## Path 2 — `.kovaleePaywall` (recommended for RevenueCat remote paywalls)

Presents the RevenueCat paywall and wires **all** tracking automatically: `page_view_paywall`, the full `payment_*` lifecycle (start/finish/cancel/failure/restore incl. restore failure), and the conversion dispatch.

```swift
import KovaleeSDKUI

MainView()
    .kovaleePaywall(
        isPresented: $showPaywall,       // gate on !isUserPremium at the call site
        offering: offering,               // nil → current offering
        source: "progress"
    ) { customerInfo in
        // optional: react to the purchase (do NOT call trackSubscriptionConversion here)
    } onDismiss: { unlocked in
        // unlocked == purchased OR restored-with-entitlement
    }
```

Prefer this for new paywalls: the fleet-wide bug this system fixes existed because every app hand-rolled RevenueCatUI callbacks and every one of them forgot the ad-SDK conversions.

Full wrapper reference — API, restore semantics, differences vs `presentPaywallIfNeeded`, migration guide: [PAYWALLS.md](PAYWALLS.md).

## Path 3 — custom RevenueCatUI wiring (escape hatch)

If you keep your own `presentPaywallIfNeeded` / `PaywallView` wiring, capture the package at purchase **start** and fire the conversion at **completion**:

```swift
import KovaleePurchases
import KovaleeSDK
import RevenueCat
import RevenueCatUI
import SwiftUI

@State private var purchasedPackage: Package?

.presentPaywallIfNeeded(requiredEntitlementIdentifier: "pro", offering: offering) { startedPackage in
    purchasedPackage = startedPackage
    Kovalee.sendEvent(event: .paymentStart(source: source, product: startedPackage.storeProduct.productIdentifier))
} purchaseCompleted: { customerInfo in
    // ...your payment_finish / premium handling...
    if let package = purchasedPackage {
        Kovalee.trackSubscriptionConversion(package: package)
    }
}
```

When RevenueCatUI's two-argument completion is available (`PaywallView`'s `.onPurchaseCompleted { transaction, customerInfo in … }`), pass the transaction — it supplies the GA4 dedup id and the transaction-level trial truth:

```swift
Kovalee.trackSubscriptionConversion(package: package, transaction: transaction)
```

## The subscription upsell (automatic)

The SDK's lifetime-upsell paywall (`SubscriptionUpsell`) fires the conversions internally. No app wiring.

---

## Per-sink requirements

### TikTok

Configure the `tiktok` block in `KovaleeKeys.json` and link `KovaleeTikTok` (unchanged). Note: TikTok has its own tracking switch (`Kovalee.setTikTokTrackingEnabled(_:)`) that the app manages alongside consent.

### Firebase

The GA4 `purchase` event requires `"analyticsEnabled": true` in the `firebase` block of `KovaleeKeys.json` (otherwise the Firebase tracker is not part of the event pipeline and the event silently has no receiver).

---

## Pitfalls

- **Never combine paths** for the same purchase (see The one rule). In particular, do not call `trackSubscriptionConversion` from a `.kovaleePaywall` completion.
- **Restores are not purchases** — no path fires conversions on restore.
- A product with a **nil currency** drops the conversion and logs a `KLogger` warning (the only trace); if a purchase is visible in Amplitude but missing from the ad sinks, look for that line.

## Verifying an integration

- **Firebase:** run with `-FIRDebugEnabled` and check GA4 DebugView for `purchase`.
- **TikTok:** TikTok Events Manager (the SDK does not log individual enqueues to the console).
- The dispatch itself (fan-out, trial/paid split, consent gate, nil-currency guard) is covered by `TikTokDispatchTests` in the KovaleeFramework test suite.
