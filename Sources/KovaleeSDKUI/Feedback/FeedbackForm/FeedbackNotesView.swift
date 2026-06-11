#if os(iOS)
import OSLog
import SwiftUI

@available(iOS 17, *)
struct FeedbackNotesView: View {
    @Environment(FeedbackFormViewModel.self) private var viewModel

    @FocusState private var isTextFieldFocused: Bool
    @State private var state = ViewState.idle
    private let injectedService: UserFeedbackService?

    init(userFeedbackService: UserFeedbackService? = nil) {
        self.injectedService = userFeedbackService
    }

    private var isShowingError: Binding<Bool> {
        Binding(
            get: { state == .failure },
            set: { isShowing in if !isShowing { state = .idle } }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStrings.featuresNotesFieldLabel)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(viewModel.primaryColor)
                    .padding(.horizontal, 20)

                textEditor
            }
        }
        .background(viewModel.backgroundColor)
        .safeAreaInset(edge: .bottom) {
            actionButton
                .background(viewModel.backgroundColor)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
        .overlay {
            if state == .sending {
                LoaderOverlay(
                    primaryColor: viewModel.primaryColor,
                    backgroundColor: viewModel.backgroundColor
                )
            }
        }
        .alert(LocalizedStrings.errorTitle, isPresented: isShowingError) {
            Button(LocalizedStrings.errorRetryButton) {
                action()
            }
            Button(LocalizedStrings.errorCancelButton, role: .cancel) {
                state = .idle
            }
        } message: {
            Text(LocalizedStrings.errorMessage)
        }
    }

    func action() {
        guard state != .sending else { return }
        let service = injectedService ?? UserFeedbackService()
        Task {
            await MainActor.run {
                state = .sending
            }
            let userFeedback = UserForm(
                question: viewModel.choicesTitle,
                feedback: viewModel.notes,
                selectedChoices: Array(viewModel.selectedChoices)
            )
            do {
                try await service.sendForm(
                    form: userFeedback,
                    metadata: viewModel.feedbackMetadata
                )
                await MainActor.run {
                    state = .success
                    viewModel.onNotesActionTapped?()
                    viewModel.currentStep = .confirmation
                }
            } catch {
                Logger.userFeedback.error("Failed to send feature feedback: \(error.localizedDescription, privacy: .public)")
                await MainActor.run {
                    state = .failure
                }
            }
        }
    }

}

@available(iOS 17, *)
extension FeedbackNotesView {

    var header: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(viewModel.notesTitle)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(viewModel.primaryColor)
                .padding(.top, 32)
            Text(viewModel.notesSubtitle)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(viewModel.secondaryColor)
        }
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }

    var textEditor: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: Binding(
                get: { viewModel.notes },
                set: { viewModel.notes = $0 }
            ))
            .font(.system(size: 17))
            .foregroundColor(viewModel.secondaryColor)
            .scrollContentBackground(.hidden)
            .frame(minHeight: 96)
            .padding(12)
            .focused($isTextFieldFocused)

            if viewModel.notes.isEmpty {
                Text(viewModel.notesPlaceholder)
                    .font(.system(size: 17))
                    .foregroundColor(viewModel.secondaryColor.opacity(0.6))
                    .padding(12)
                    .offset(x: 3, y: 8)
                    .allowsHitTesting(false)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(viewModel.secondaryBackgroundColor)
        )
        .padding(.horizontal, 20)
    }

    var actionButton: some View {
        Button(action: action) {
            Text(LocalizedStrings.featuresNotesButton)
                .font(.headline.bold())
                .foregroundColor(viewModel.ctaColor.isLight ? .black : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(viewModel.ctaColor)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

@available(iOS 17, *)
private enum ViewState {
    case idle
    case sending
    case success
    case failure
}
#endif
