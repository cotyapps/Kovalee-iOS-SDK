# RevenueCat Paywalls

`KovaleeSDKUI` ships a drop-in way to present **RevenueCat-hosted (remote) paywalls** with every piece of Kovalee tracking wired automatically:

| What fires | When |
|------------|------|
| `page_view_paywall` (with `source`) | the paywall actually appears |
| `payment_start` (with product id) | user starts a purchase |
| `payment_finish` + **conversion dispatch** (TikTok + Firebase, with value) | purchase completes |
| `payment_cancel` / `payment_failure` | user cancels / purchase fails |
| `payment_restore_start` / `finish` / `fail` | restore lifecycle, including failure |

The paywall itself is RevenueCatUI's `PaywallView` — it renders the paywall template configured for the offering in the RevenueCat dashboard, so design changes ship without app updates.

## Quick start

```swift
import KovaleeSDKUI
import RevenueCat
import SwiftUI

struct MainView: View {
    @State private var showPaywall = false
    @State private var offering: Offering?

    var body: some View {
        content
            .kovaleePaywall(
                isPresented: $showPaywall,
                offering: offering,            // nil → the RC "current" offering
                source: "progress"             // analytics source for all events
            ) { customerInfo in
                // optional: runs after a successful purchase
            } onDismiss: { unlocked in
                if unlocked { isUserPremium = true }
            }
    }
}
```

## API

```swift
func kovaleePaywall(
    isPresented: Binding<Bool>,
    offering: Offering? = nil,
    source: String,
    onPurchaseCompleted: ((CustomerInfo) -> Void)? = nil,
    onDismiss: ((Bool) -> Void)? = nil
) -> some View
```

| Parameter | Role |
|-----------|------|
| `isPresented` | shows/hides the paywall (full-screen cover). **Gate it on `!isUserPremium` at the call site** — the wrapper does not check entitlements itself. |
| `offering` | the RevenueCat `Offering` to render; `nil` uses the dashboard's current offering. Fetch per your app's logic (AB-test variant, placement, …). |
| `source` | the analytics `source` attached to every paywall/payment event (e.g. `"onboarding"`, `"progress"`). |
| `onPurchaseCompleted` | optional hook after a successful purchase. ⚠️ Do **not** call `Kovalee.trackSubscriptionConversion` here — the wrapper already fired it (see [PURCHASE_TRACKING.md](PURCHASE_TRACKING.md)). |
| `onDismiss` | called when the cover closes; the `Bool` means **unlocked** — the user purchased *or* restored an active entitlement. |

## Behavior details

- **Purchase completion** dismisses the paywall and reports `onDismiss(true)`.
- **Restore** fires the restore events; if the restore actually recovered an entitlement the paywall dismisses and reports `onDismiss(true)` — a restore that finds nothing leaves the paywall up (and never unlocks premium).
- **Close (X / dismiss gesture)** reports `onDismiss(false)`.
- The conversion carries the **transaction id** and **transaction-level trial detection** (a re-subscriber who isn't intro-eligible is reported as a paid purchase, not a trial).
- Consent: everything is gated by `Kovalee.setDataCollectionEnabled(_:)`.

## Differences vs. hand-rolled `presentPaywallIfNeeded`

| | `.kovaleePaywall` | raw `presentPaywallIfNeeded` |
|---|---|---|
| Entitlement gating | caller's job (`isPresented`) | built-in (`requiredEntitlementIdentifier`) |
| `page_view_paywall` | fired only when the paywall really appears | typically fired on modifier evaluation — over-counts when presentation is declined |
| Payment events + ad-SDK conversions | automatic, complete | every app re-implements them (historically: all of them forgot the conversions) |
| Restore failure event | wired | usually forgotten |

If you must keep custom RevenueCatUI wiring (special presentation needs), follow **Path 3** in [PURCHASE_TRACKING.md](PURCHASE_TRACKING.md) — capture the package at `purchaseStarted`, call `Kovalee.trackSubscriptionConversion(package:transaction:)` at completion.

## Migrating an existing hand-rolled paywall

Before (typical app modifier):

```swift
.presentPaywallIfNeeded(requiredEntitlementIdentifier: "pro", offering: offering) { _ in
    Kovalee.sendEvent(event: .paymentStart(source: source, product: ""))
} purchaseCompleted: { customerInfo in
    Kovalee.sendEvent(event: .paymentFinish(source: source, product: ...))
    isUserPremium = true
} purchaseCancelled: { ... } restoreCompleted: { ... } // etc.
```

After:

```swift
.kovaleePaywall(isPresented: $showPaywall, offering: offering, source: source) { _ in
    isUserPremium = true
} onDismiss: { unlocked in
    if unlocked { isUserPremium = true }
}
```

Delete the manual `sendEvent` calls — the wrapper fires them all (and adds the conversions your version was missing). Keep the premium-flag handling: that remains app state.

## Related

- **Conversion tracking in depth** (per-sink requirements, pitfalls, verification): [PURCHASE_TRACKING.md](PURCHASE_TRACKING.md)
- **Trial-expiry lifetime upsell** (a specialized, fully-managed RC paywall flow with post-purchase screens): see *Subscription Upsell* in the README — it fires the same conversions internally.
