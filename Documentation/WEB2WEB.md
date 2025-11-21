# Web2Web Integration

Starting from version 2.2.0 of Kovalee iOS SDK, Web2Web is supported. 

In order to works correctly the app needs to supports deeplinks that follow the format below (the Kovalee team will configure it for you):

```
https://appname.go.link/web2web?adj_t=123456&adj_linkme=1&user_id={{user.id}}
```


## Supporting deeplinks to makes the user premium

### For SwiftUI apps only (easy way)

Just add the view modifier `checkWebUserPremium` from KovaleeSDK to your main view.

```swift
import KovaleeSDK

@main
struct MyApp: App {

    var body: some Scene {
        WindowGroup {
            ... // your implementation
        }
        .checkWebUserPremium(
            readPasteboard: true, // the default value is true
            isUserPremium: { premiumStatus in
                // update your logic as needed
                // skip onboarding or just don't show the paywall
                ...
            },
            onError: { error in
                print("Error checking web user status: \(error)")
            }
        )
    }
}
```

### For UIKit apps or manually for SwiftUI apps (2 steps)

#### Read deeplink from the pasteboard at launch

After initializing the Kovalee SDK, add this code to check the premium status:

```swift
Task {
    do {
        let isPremium = try await Kovalee.checkIfWebUserIsPremiumOnFirstLaunch()
        print("Is the user premium from the web? \(isPremium)")
    } catch {
        print("Error checking premium status from clipboard: \(error)")
    }
}
```
#### Support for deeplinks and deferred deeplinks

Add the following to your AppDelegate:

```swift
func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
) -> Bool {
    Task {
        do {
            let isPremium = try await Kovalee.isWebUserPremium(withUrl: url)
            print("Is the web user premium? \(isPremium)")
        } catch {
            print("Error checking premium status for web user: \(error)")
        }
    }
    return true
}
```


## Let the user manage and cancel its subscription

It is important to let the user cancel its subscription inside the app. A good practice is to show a button to do so on a settings view.

### Cancel user subscription

```swift
Task {
    do {
        let success = try await Kovalee.cancelStripeSubscription()
        print("Was the web subscription cancelled? \(success)")
    } catch {
        print("Error while cancelling subscription: \(error)")
    }
}
```

### Check if the user has a cancellable subscription

You can check if the user still has a subscription that can be cancelled, for example to hide or show a cancelation button.

```swift
struct ContentView: View {
    @State private var showCancelButton: Bool = false

    var body: some View {
        VStack {
            ....
            if showCancelButton {
                Button("Cancel subscription") {
                    // Cancel subscription
                }
            }
        }
        .task {
            do {
                let hasActiveStripeSubscription = try await Kovalee.hasActiveStripeSubscription()
                showCancelButton = hasActiveStripeSubscription
            } catch {
                print("Error checking active subscription: \(error)")
            }
        }
    }
}
```
