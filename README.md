# Kovalee-SDK
KovaleeSDK is an efficient iOS framework, that's packed with tools specifically for tracking user behavior, handling user purchases, and smoothly integrating ads.

We all know that integrating tracking tools can feel like solving a Rubik's cube. The hurdles of Apple's restrictions and the hoops we jump through with third-party frameworks make the process complex and time-consuming.

We've tackled this issue head-on at Kovalee. `KovaleeSDK` is our answer - a framework designed to handle the heavy lifting, automating many of the typically tedious steps and wrapping much of the tracking functionality into the SDK.

`KovaleeSDK` is split into multiple modules, distributed through SPM, each one taking care of a different area. 
- KovaleeAttribution
- KovaleePurchases
- KovaleeRemoteConfig
- KovaleeTikTok

## **Installation**

### 📦 **Swift Package**
The package can be simply installed as a dependency from XCode.

- Add a package by selecting `File` → `Add Packages…` in Xcode’s menu bar.
- Search for the Kovalee iOS SDK using the repo's URL:
  ```console
  https://github.com/cotyapps/Kovalee-iOS-SDK
  ```
- Set the **Dependency Rule** to be `Up to Next Major Version`.
- Select **Add Package**. 
  
And you are good to go.

## Requirements

| Platform | Minimum target |
| -------- | -------------- |
| iOS      | 15.0+          |


## Integration
To properly work, this Package needs a set of configurations files that should be created by the team @Kovalee.

If you are interested in using this package for your iOS app, feel free to get in contact.

## Configuration

Initialize the SDK in your `AppDelegate` or app entry point. Use the `.development` environment during development for debug logging, and `.production` for release builds:

**UIKit (AppDelegate):**

```swift
import KovaleeSDK

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _: UIApplication,
        willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        #if DEBUG
        let configuration = Configuration(environment: .development, logLevel: .debug)
        #else
        let configuration = Configuration(environment: .production)
        #endif

        Kovalee.initialize(configuration: configuration)
        return true
    }
}
```

**SwiftUI:**

```swift
import SwiftUI
import KovaleeSDK

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

## Amplitude Session Replay

KovaleeSDK supports [Amplitude Session Replay](https://amplitude.com/docs/session-replay), which lets you capture and replay user sessions to better understand user behavior in your app.

### Enabling Session Replay

To enable Amplitude Session Replay, set `enableAmplitudeSessionReplay` to `true` in your `Configuration`:

```swift
Kovalee.initialize(
    configuration: Configuration(
        environment: .production,
        enableAmplitudeSessionReplay: true
    )
)
```

Session Replay is disabled by default. When enabled, the SDK automatically adds the `AmplitudeSwiftSessionReplayPlugin` to the Amplitude instance, and session replays will be available in your Amplitude dashboard.

## TikTok Integration

KovaleeSDK supports [TikTok Events API](https://business-api.tiktok.com/portal/docs?id=1771100865818625) through the `KovaleeTikTok` module, allowing you to track app events and send them to TikTok for ad attribution and optimization.

### Setup

1. Add the `KovaleeTikTok` library to your app target in Xcode:
   - Select your app target → **General** → **Frameworks, Libraries, and Embedded Content** → **+** → select `KovaleeTikTok`

2. Add your TikTok credentials to `KovaleeKeys.json`:
   ```json
   {
     "tiktok": {
       "appId": "YOUR_APP_ID",
       "tiktokAppId": "YOUR_TIKTOK_APP_ID",
       "accessToken": "YOUR_ACCESS_TOKEN"
     }
   }
   ```

3. Add `import KovaleeTikTok` alongside `KovaleeSDK` where you initialize the SDK:
   ```swift
   import KovaleeSDK
   import KovaleeTikTok
   ```

TikTok will be automatically initialized during `Kovalee.initialize()` when the keys are present. No additional setup call is needed.

If you don't have TikTok integration keys, reach out to the Kovalee team to get them configured for your app.

### Usage

```swift
// Track an event
Kovalee.trackTikTokEvent("purchase", properties: ["value": 9.99, "currency": "USD"])

// Identify a user
Kovalee.identifyTikTokUser(externalId: "user_123", email: "user@example.com")

// Logout
Kovalee.logoutTikTok()

// Enable/disable tracking
Kovalee.setTikTokTrackingEnabled(false)

// Flush queued events
Kovalee.flushTikTokEvents()
```

## Subscription Upsell

KovaleeSDKUI ships a turnkey flow for users on an expiring free trial: detect the trial → present a RevenueCat-hosted upsell paywall (typically lifetime) → on purchase, route the user to Apple's *Manage Subscriptions* sheet so they can turn off auto-renewal on the original subscription (Apple does not allow developer-side cancellation).

The host app never sees subscription state, paywall internals, or the manage-subscriptions sheet — it provides configuration and (optionally) receives the final outcome.

### Setup

1. Add the `KovaleeSDKUI` library to your app target. It depends on `RevenueCatUI`, which is fetched automatically.

2. Build a `Configuration`:

   ```swift
   import KovaleeSDKUI

   let upsellConfig = SubscriptionUpsell.Configuration(
       offeringId: "lifetime_upsell",          // RevenueCat offering to present
       trigger: .yearly,                        // watch for an expiring yearly trial
       triggerWithin: 48 * 3600,                // …expiring within 48h (default: 48h, optional)
       storageKey: "trial_to_lifetime_v1",      // namespace for the show-once flag
       showCloseButton: false,                  // overlay an X if your paywall has no dismiss UI (default: false)
       cancelPromptTheme: nil                   // use the default congrats-screen theme (default: nil)
   )
   ```

   `offeringId`, `trigger`, and `storageKey` are required; everything else has a default. `trigger` can be `.yearly`, `.monthly`, `.weekly`, `.anySubscription`, or `.productIdentifiers([...])` for explicit product IDs.

### Usage

**SwiftUI** — drop the modifier on your root view. It runs the check on appear and on every foreground; the show-once flag (keyed by `storageKey`) keeps it idempotent.

```swift
ContentView()
    .checkSubscriptionUpsell(configuration: upsellConfig) { outcome in
        // .notTriggered | .dismissed | .purchased
    }
```

**UIKit** — call from the view controller that should host the paywall:

```swift
SubscriptionUpsell.checkAndPresentIfNeeded(
    configuration: upsellConfig,
    from: self
) { outcome in
    // …
}
```

**Deep link / marketing re-engagement** — bypass the trial-detection and show-once gates and present unconditionally. The built-in handler matches `<scheme>://upsell` (custom schemes only — `http`/`https` are refused):

```swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url,
          let root = scene.keyWindow?.rootViewController else { return }

    if SubscriptionUpsell.handleDeepLink(url, configuration: upsellConfig, from: root) {
        return
    }
    // …your other deep-link handlers
}
```

Or present directly:

```swift
SubscriptionUpsell.presentNow(configuration: upsellConfig, from: presenter)
```

### Theming the congrats screen

The post-purchase "Lifetime unlocked" screen is themable. Register a global default at launch so QA and debug previews match production:

```swift
SubscriptionUpsell.defaultCancelPromptTheme = SubscriptionUpsell.Theme(
    background: .black,
    iconTint: .yellow,
    primaryButtonBackground: .yellow,
    primaryButtonForeground: .black,
    iconSystemName: "crown.fill"
)
```

Per-call overrides take precedence via `Configuration.cancelPromptTheme`.

### Debug / QA

The SDK's `DebugView` exposes a *Subscription Upsell* section (visible when **Enable Debug Mode** is on) with:

- **Force Trigger on Launch** — behaves as if a matching trial entitlement existed, regardless of subscription state. Gated to debug/TestFlight builds.
- **Reset Shown State** — clears the show-once flag so the flow can fire again.
- **Preview Congrats Screen** — opens the post-purchase screen directly to validate theming.

### Outcomes

| Outcome | Meaning |
| --- | --- |
| `.notTriggered` | No expiring trial, the flow already ran for this `storageKey`, or the offering / network lookup failed. |
| `.dismissed` | The user closed the paywall without purchasing. |
| `.purchased` | The upsell was purchased. Fires after the congrats screen is dismissed. |

