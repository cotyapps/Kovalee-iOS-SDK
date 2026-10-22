# Google On-Device Conversion Measurement (ODM)

Google's on-device conversion measurement lets Google Ads measure iOS App campaign conversions without the IDFA. It runs through two paths, and Google recommends both:

| Path | What it needs | Who provides it |
|------|---------------|-----------------|
| **Adjust** | Adjust SDK 5.4.1+ with the `AdjustGoogleOdm` module | `KovaleeAttribution` (automatic) |
| **Firebase** ("event data") | Firebase 12.12.1+ with ad storage granted at first launch | `KovaleeSDK` (Firebase Analytics) + your `Info.plist` |

`KovaleeAttribution` links `AdjustGoogleOdm` on iOS and requires Adjust 5.4.1 or newer. The SDK requires Firebase 13.0.1 or newer. There is nothing to call: Adjust finds the ODM plugin at runtime, and Firebase starts ODM on its own at first launch.

ODM is not active for users in the EEA, the UK and Switzerland.

---

## What to do in your app

### 1. Update the SDK

Update `Kovalee-iOS-SDK` to **2.6.5 or newer** (`Up to Next Major Version`). If you pinned an exact version, change it.

If your app also references `firebase-ios-sdk` directly and caps it at 12.x, raise it to `Up to Next Major` from `13.0.1`, or the packages won't resolve. The same applies to a direct `adjust/ios_sdk` reference below 5.4.1.

After resolving, `Package.resolved` should show:

| Package | Version |
|---------|---------|
| `kovalee-ios-sdk` | 2.6.5+ |
| `ios_sdk` | 5.4.1+ |
| `firebase-ios-sdk` | 13.0.1+ |
| `google-ads-on-device-conversion-ios-sdk` | 3.7.x |

If your app already links `AdjustGoogleOdm` itself, you can keep it or remove it; linking it twice is harmless.

### 2. Don't deny ad storage at first launch

Firebase tries ODM **once**, a few seconds after the app's first launch, and never retries. If `ad_storage` is denied at that moment, Firebase ODM is off for that install for good, even if the user later allows tracking.

Set these consent defaults in `Info.plist` (or leave `GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_STORAGE` out, which Firebase treats as granted):

```xml
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_ANALYTICS_STORAGE</key>
<true/>
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_STORAGE</key>
<true/>
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_USER_DATA</key>
<false/>
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_PERSONALIZATION_SIGNALS</key>
<false/>
```

Never set `GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_STORAGE` to `false`. The IDFA stays unavailable until the user allows tracking either way.

### 3. Ask for tracking through the SDK

Call `Kovalee.promptTrackingAuthorization()` rather than `ATTrackingManager` directly. On **Allow** the SDK grants Firebase's three ad consents; on any other answer it denies them.

Call it while the app is active, and again whenever it becomes active (for example on `didBecomeActiveNotification`). Once the user has answered, the call returns immediately without showing the prompt and re-applies their answer, so a late answer is never missed.

```swift
.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
    Task { await Kovalee.promptTrackingAuthorization() }
}
```

### 4. Verify on a fresh install

Delete the app, run a Debug build with the launch argument `-FIRAnalyticsDebugEnabled`, and look for these log lines within about 15 seconds of launch:

| What you see | What it means |
|--------------|---------------|
| `adj_google_odm_info_processed = 1` (UserDefaults) | Adjust ODM works |
| `I-ACS023277 Conversion service enabled`, then `I-ACS023087 User property set … _psmvalue_gads` | Firebase ODM works |
| `I-ACS023275 Conversion service disabled. Remote config disabled. Check ads account linked to Google Analytics` repeating, plus `Ads account not linked to Google Analytics` | Google Ads isn't linked to the app's GA4 property (dashboard fix, below) |
| `I-ACS023307 … Ad storage consent is denied` | Ad storage was denied at first launch (step 2) |

Only installs of a build with these changes are measured, since Firebase only tries ODM at first launch.

---

## Outside the code

These dashboard settings are needed too, and are usually handled by UA:

- **Google Ads:** import Adjust's `first_open` and `session_start` events (plus the purchase event) as conversions. Without them, Google never receives the ODM data Adjust sends.
- **Adjust:** turn on probabilistic modeling for clicks and impressions with a **24 h** window (the default is 6 h), at app level and on the Google Ads links.
- **GA4:** link the Google Ads account to the app's Firebase project (Admin → Product links → Google Ads links).
