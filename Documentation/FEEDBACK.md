# In-App Feedback

`KovaleeSDKUI` ships two ready-made feedback flows you can present from anywhere in your app:

| Flow | What it collects | Backend (Firebase callable) |
|------|------------------|------------------------------|
| **Founder** | Free-form message + email + phone | `writeToSheet` |
| **Features** | Multi-choice survey → optional notes → confirmation | `sendForm` |

Both are SwiftUI views, available on **iOS 17+**, and auto-fill device/user metadata from the SDK.

```swift
import KovaleeSDKUI
```

The recommended entry point is **`FeedbackCoordinator`** (SwiftUI). For UIKit screens you can present the views directly with a `UIHostingController`. Both approaches are shown below.

## Examples

The flows, step by step, themed and shipping in real apps.

### Founder flow — intro → form

| | Intro | Form |
|---|:---:|:---:|
| **Example** | <img src="images/75hard-founder.png" width="220"> | <img src="images/75hard-founder-form.png" width="220"> |

After the user submits, a success alert confirms delivery.

### Features survey — choices → notes → confirmation

**Example** (all three steps):

| Choices | Notes | Confirmation |
|:---:|:---:|:---:|
| <img src="images/75hard-feature-survey.png" width="220"> | <img src="images/75hard-feature-notes.png" width="220"> | <img src="images/75hard-feature-confirmation.png" width="220"> |

`FeedbackNotesView` and `FeedbackConfirmationView` are internal to the SDK (only rendered inside `FeedbackFormView`), so they're reached by rendering `FeedbackFormView` seeded to a step via its `initialStepIndex` parameter — that's how the notes/confirmation captures above were produced (via the `Goals Feedback Notes` / `Goals Feedback Confirmation` Prefire previews).

---

## Metadata

Every submission carries a `FeedbackMetadata` (OS version, app version, RevenueCat id, Amplitude id, subscription status).

Let the SDK build it for you:

```swift
let metadata = await FeedbackMetadata.fromKovalee()
```

The `showFounder(text:…)` / `showFeatures(text:…)` coordinator helpers call this for you — you only pass it manually when constructing a configuration yourself.

---

## Founder flow

An intro screen (image + title + body + CTA) that leads to a short form (message, email, phone). On submit it calls the `writeToSheet` Firebase function.

### SwiftUI

Hold a `FeedbackCoordinator`, attach the `.userFeedback(coordinator:)` modifier, and call `showFounder`:

```swift
struct SettingsView: View {
    @State private var feedback = FeedbackCoordinator()

    var body: some View {
        Button("Contact support") {
            feedback.showFounder(
                text: FeedbackText(
                    cta: "Send feedback",
                    title: "Hey, I'm Dave, the founder.",
                    introText: "Tell me what's working and what I should build next.",
                    imageName: "founder-photo",   // an asset in YOUR app bundle
                    successText: "Thanks for your feedback!"
                ),
                style: .myAppStyle          // optional, see Styling
            )
        }
        .userFeedback(coordinator: feedback)   // presents the sheet
    }
}
```

`showFounder` auto-fills metadata. The `.userFeedback(coordinator:)` modifier is what actually presents the sheet — without it nothing happens.

### UIKit

Present the view directly. You build the metadata and configuration yourself:

```swift
@IBAction func contactSupport(_ sender: Any) {
    Task {
        let configuration = UserFeedbackConfiguration(
            feedbackText: FeedbackText(
                cta: "Send feedback",
                title: "Hey, I'm Dave, the founder.",
                introText: "Tell me what's working and what I should build next.",
                imageName: "founder-photo",
                successText: "Thanks for your feedback!"
            ),
            feedbackStyle: .myAppStyle,                 // optional
            feedbackMetadata: await .fromKovalee()
        )
        present(
            UIHostingController(rootView: UserFeedbackView(configuration: configuration, showBackButton: true)),
            animated: true
        )
    }
}
```

`showBackButton: true` adds a top-trailing ✕ to dismiss the sheet.

---

## Features survey

A 3-step flow: **choices** (multi-select) → **notes** (optional free text) → **confirmation**. On the notes step it calls the `sendForm` Firebase function with the selected choices and notes.

### SwiftUI

```swift
struct HomeView: View {
    @State private var feedback = FeedbackCoordinator()

    var body: some View {
        content
            .userFeedback(coordinator: feedback)
            .onAppear { showSurveyIfNeeded() }
    }

    private func showSurveyIfNeeded() {
        feedback.showFeatures(
            text: FeatureFeedbackText(
                choicesTitle: "What should we build next?",
                choicesSubtitle: "Pick the features you'd use most.",
                notesTitle: "Anything else?",
                notesSubtitle: "Tell us what would make the app better.",
                notesPlaceholder: "Type here…",
                confirmationTitle: "Feedback received",
                confirmationMessage: "Thanks for helping shape the app."
            ),
            appIcon: Image("app-icon"),      // shown on the confirmation screen
            choices: [
                "Daily journal",
                "Streaks",
                "Community challenges",
                "Others"
            ],
            style: .myFeatureStyle,          // optional, see Styling
            onChoicesButtonTapped: { Analytics.log("survey_choices_submitted") },
            onNotesActionTapped: { Analytics.log("survey_completed") }
        )
    }
}
```

`onChoicesButtonTapped` fires when the user advances past the choices step; `onNotesActionTapped` fires when the form is sent — use them for analytics.

#### Reusing a configuration

If you present the same survey from more than one place (or want a preview), factor it into a `FeatureFeedbackConfiguration` extension and pass it to `showFeatures(_:)`:

```swift
extension FeatureFeedbackConfiguration {
    @MainActor static func appSurvey(metadata: FeedbackMetadata) -> FeatureFeedbackConfiguration {
        FeatureFeedbackConfiguration(
            style: .myFeatureStyle,
            text: FeatureFeedbackText(/* … */),
            appIcon: Image("app-icon"),
            choices: [/* … */],
            metadata: metadata,
            onChoicesButtonTapped: { Analytics.log("survey_choices_submitted") },
            onNotesActionTapped: { Analytics.log("survey_completed") }
        )
    }
}

// then:
feedback.showFeatures(.appSurvey(metadata: await .fromKovalee()))
```

### UIKit

Present `FeedbackFormView` directly. Easiest is to drive it from a `FeatureFeedbackConfiguration`:

```swift
Task {
    let config = FeatureFeedbackConfiguration.appSurvey(metadata: await .fromKovalee())
    let form = FeedbackFormView(
        primaryColor: config.style.primaryColor,
        secondaryColor: config.style.secondaryColor,
        backgroundColor: config.style.backgroundColor,
        secondaryBackgroundColor: config.style.secondaryBackgroundColor,
        ctaColor: config.style.ctaColor,
        selectedColor: config.style.selectedColor,
        unselectedColor: config.style.unselectedColor,
        buttonCornerRadius: config.style.buttonCornerRadius,
        appIcon: config.appIcon,
        choices: config.choices,
        choicesTitle: config.text.choicesTitle,
        choicesSubtitle: config.text.choicesSubtitle,
        notesTitle: config.text.notesTitle,
        notesSubtitle: config.text.notesSubtitle,
        notesPlaceholder: config.text.notesPlaceholder,
        confirmationTitle: config.text.confirmationTitle,
        confirmationMessage: config.text.confirmationMessage,
        feedbackMetadata: config.metadata,
        onComplete: { [weak self] in self?.dismiss(animated: true) },
        onChoicesButtonTapped: config.onChoicesButtonTapped,
        onNotesActionTapped: config.onNotesActionTapped
    )
    present(UIHostingController(rootView: form), animated: true)
}
```

---

## Styling

Each flow has its own style type. All fields are defaulted, so `.default` works out of the box.

**Founder — `FeedbackStyle`:**

```swift
extension FeedbackStyle {
    static let myAppStyle = FeedbackStyle(
        backgroundColor: Color("background"),
        textColor: .white.opacity(0.8),
        titlesColor: .white,
        fieldBackgroundColor: Color("card"),
        submitButtonColor: Color("accent"),
        symbol: nil                       // optional SF Symbol on the CTA
    )
}
```

**Features — `FeatureFeedbackStyle`:**

```swift
extension FeatureFeedbackStyle {
    static let myFeatureStyle = FeatureFeedbackStyle(
        primaryColor: .white,             // titles
        secondaryColor: Color("accent"),  // subtitle / notes text
        backgroundColor: Color("background"),
        secondaryBackgroundColor: Color("card"), // unselected chip background
        ctaColor: Color("accent"),        // CTA + selected chip (tinted bg & border)
        selectedColor: .white,            // selected chip label
        unselectedColor: .white,          // unselected chip label
        buttonCornerRadius: 16            // CTA / chip corner radius
    )
}
```

> Note: the selected chip uses `ctaColor` (a faint `ctaColor.opacity(0.06)` fill with a `ctaColor` border), the unselected chip uses `secondaryBackgroundColor`, and `secondaryColor` is the subtitle / notes-text color.

---

## Notes

- All views require **iOS 17+** (`@available(iOS 17, *)`).
- The founder `imageName` and the features `appIcon` must resolve to assets in **your app's** bundle.
- Submissions show a retry alert when the Firebase callable fails; make sure the `writeToSheet` / `sendForm` callables exist in your project.
- `FeedbackCoordinator` is `@MainActor @Observable`; create it with `@State` in SwiftUI and keep one instance per host view.
