import SuperwallKit
import SwiftUI

struct PaywallViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: PaywallViewController

    func makeUIViewController(context _: Context) -> some UIViewController {
        return viewController
    }

    func updateUIViewController(_: UIViewControllerType, context _: Context) {}
}

struct SuperwallPaywallView<Paywall: View>: View {
    let event: String
    let params: [String: Any]?

    var alternativePaywall: AlternativePaywall<Paywall>?
    var onComplete: (PaywallPresentationError?) -> Void

    enum ViewState {
        case loading
        case paywall(PaywallViewController)
        case alternativePaywall(AlternativePaywall<Paywall>)
    }

    init(
        event: String,
        params: [String: Any]?,
        alternativePaywall: AlternativePaywall<Paywall>?,
        onComplete: @escaping (PaywallPresentationError?) -> Void
    ) {
        self.event = event
        self.params = params
        self.alternativePaywall = alternativePaywall
        self.onComplete = onComplete
        paywallHandler.onComplete = onComplete
    }

    private var paywallHandler = SuperwallPaywallHandler.shared
    @State private var viewState: ViewState = .loading

    var body: some View {
        Group {
            switch viewState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity)
            case let .paywall(paywall):
                PaywallViewControllerWrapper(viewController: paywall)
                    .ignoresSafeArea(edges: .all)
            case let .alternativePaywall(alternativePaywall):
                alternativePaywall
            }
        }
        .onAppear {
            Task {
                await loadPaywallController()
            }
        }
    }

    private func loadPaywallController() async {
        do {
            let paywall = try await paywallHandler.retrievePaywall(event: event, params: params)
            viewState = .paywall(paywall)
        } catch {
            guard let reason = error as? PaywallSkippedReason else {
                onComplete(.unknownError)
                return
            }
            let mappedError = PaywallPresentationError.mapFromSuperwall(reason: reason)

            if case .holdout = mappedError, let alternativePaywall {
                viewState = .alternativePaywall(alternativePaywall)
            } else {
                onComplete(mappedError)
            }
        }
    }
}
