import KovaleeSDK
import SuperwallKit
import SwiftUI

// MARK: Kovalee Paywall

/// `PaywallView` is a SwiftUI view that presents a paywall configured in Superwall.
///
/// This view is used to show a paywall based on various triggers and parameters.
/// It utilizes `Superwall` for the actual presentation and handles the completion event through a provided closure.
///
/// ## Topics
///
/// ### Initializing a Paywall View
/// - ``PaywallView/init(trigger:source:params:alternativePaywall:onComplete:)``
///
/// ## Example
///
/// ```swift
/// PaywallView(
///     trigger: "user_trial_ended",
///     params: ["user_id": "12345"],
///        alternativePaywall: AlternativePaywall(variant: "0002") {
///            VStack {
///                Text("This is an Alternative paywall")
///                Button("Dismiss") {
///                    displayPaywall.toggle()
///                }
///            }
///        },
///     onComplete: { error in
///         isPresented = false
///     }
/// )
/// ```
public struct PaywallView<Paywall: View>: View {
    private let trigger: String
    private let params: [String: Any]?
    private let alternativePaywall: AlternativePaywall<Paywall>
    private var onComplete: (PaywallPresentationError?) -> Void

    /// Creates a `PaywallView` instance.
    ///
    /// - Parameters:
    ///   - trigger: The event trigger for showing the paywall. It refers to the event_name in Superwall.
    ///   - params: Optional parameters to send to Superwall for filtering audiences.
    ///   - alternativePaywall: View to be presented in case the designated paywall can't be shown. It must contain a variat value to send in case of AB test.
    ///   - onComplete: A closure called upon the completion of the paywall interaction. It will return an optional presentation error in case of issues presenting the designated paywall.
    public init(
        trigger: String,
        params: [String: Any]? = nil,
        alternativePaywall: AlternativePaywall<Paywall>,
        onComplete: @escaping (PaywallPresentationError?) -> Void
    ) {
        self.trigger = trigger
        self.params = params
        self.onComplete = onComplete
        self.alternativePaywall = alternativePaywall
    }

    /// Creates a `PaywallView` instance.
    ///
    /// - Parameters:
    ///   - trigger: The event trigger for showing the paywall. It refers to the event_name in Superwall.
    ///   - params: Optional parameters to send to Superwall for filtering audiences.
    ///   - onComplete: A closure called upon the completion of the paywall interaction. It will return an optional presentation error in case of issues presenting the designated paywall.
    public init(
        trigger: String,
        params: [String: Any]? = nil,
        onComplete: @escaping (PaywallPresentationError?) -> Void
    ) where Paywall == EmptyView {
        self.trigger = trigger
        self.params = params
        self.onComplete = onComplete
        alternativePaywall = AlternativePaywall(variant: "", paywall: { EmptyView() })
    }

    public var body: some View {
        SuperwallPaywallView(
            event: trigger,
            params: params,
            alternativePaywall: alternativePaywall,
            onComplete: onComplete
        )
    }
}

/// `AlternativePaywall` is a generic SwiftUI view struct that encapsulates a user-defined view.
///
/// This structure allows you to define a customizable paywall component in your SwiftUI application.
/// It's generic over `Content`, which is a type that conforms to the `View` protocol. This flexibility
/// allows `AlternativePaywall` to wrap any SwiftUI view.
///
/// `AlternativePaywall` is used in case a user is part of a specific variant that doesn't have any Superwall paywall associated to it.
///
/// - Parameters:
///   - variant: A `String` that can be used to identify different variants of the paywall.
///   - paywall: A closure that returns a `Content` view.
///
public struct AlternativePaywall<Content: View>: View {
    var variant: String
    let paywall: () -> Content

    public var body: some View {
        paywall()
            .onAppear {
                Task {
                    await Kovalee.handlePaywallABTest(withVariant: variant)
                }
            }
    }

    public init(variant: String, @ViewBuilder paywall: @escaping () -> Content) {
        self.variant = variant
        self.paywall = paywall
    }
}

public enum PaywallPresentationError: Error {
    /// The user was assigned to a holdout.
    ///
    /// A holdout is a control group which you can analyse against
    /// who don't receive any paywall when they match a rule.
    case holdout

    /// No rule was matched for this event.
    case noRuleMatch

    /// This event was not found on the dashboard.
    case eventNotFound

    /// The user is subscribed.
    case userIsSubscribed

    case unknownError
}

extension PaywallPresentationError {
    static func mapFromSuperwall(reason: PaywallSkippedReason) -> Self {
        switch reason {
        case .holdout:
            .holdout
        case .noRuleMatch:
            .noRuleMatch
        case .eventNotFound:
            .eventNotFound
        case .userIsSubscribed:
            .userIsSubscribed
        }
    }
}
