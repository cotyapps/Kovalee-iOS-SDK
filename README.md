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
