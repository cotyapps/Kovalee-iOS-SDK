#if os(iOS)
import SwiftUI

@available(iOS 17, *)
struct FeedbackConfirmationView: View {
    @Environment(FeedbackFormViewModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                viewModel.appIcon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                VStack(spacing: 12) {
                    Text(viewModel.confirmationTitle)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(viewModel.primaryColor)

                    Text(viewModel.confirmationMessage)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(viewModel.secondaryColor)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            Button(action: viewModel.onComplete) {
                Text(LocalizedStrings.featuresConfirmationButton)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(viewModel.ctaColor)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(viewModel.backgroundColor)
    }
}
#endif
