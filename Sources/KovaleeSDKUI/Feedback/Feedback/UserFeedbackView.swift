#if os(iOS)
import SwiftUI

@available(iOS 17, *)
public struct UserFeedbackView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showFeedbackForm = false

    public let configuration: UserFeedbackConfiguration
    public let showBackButton: Bool
    private var style: FeedbackStyle {
        configuration.feedbackStyle
    }

    private var text: FeedbackText {
        configuration.feedbackText
    }

    public init(configuration: UserFeedbackConfiguration, showBackButton: Bool = false) {
        self.configuration = configuration
        self.showBackButton = showBackButton
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()
                if !text.imageName.isEmpty {
                    Image(text.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 136, height: 136)
                        .clipShape(Circle())
                }

                Text(text.title)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(style.titlesColor)
                    .frame(maxWidth: .infinity, alignment: .top)

                Text(text.introText)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .foregroundColor(style.textColor)
                    .frame(maxWidth: .infinity, alignment: .top)

                Spacer()

                ActionButton(
                    text: text.cta,
                    symbol: style.symbol, style: style,
                    isDisabled: false,
                    onSubmitAction: onSubmitAction
                )
                if let secondaryButton = configuration.secondaryButton {
                    Button(action: secondaryButton.action) {
                        Text(secondaryButton.text)
                            .foregroundStyle(style.textColor)
                            .font(.system(size: 15))
                    }
                }
            }
            .padding(16)
            .background(style.backgroundColor)
            .toolbar {
                if showBackButton {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(style.textColor)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showFeedbackForm) {
                UserFeedbackFormView(
                    configuration: configuration,
                    onCompletion: { dismiss() }
                )
            }
        }
        .tint(style.titlesColor)
    }
}

@available(iOS 17, *)
extension UserFeedbackView {
    func onSubmitAction() {
        showFeedbackForm = true
    }
}
#endif
