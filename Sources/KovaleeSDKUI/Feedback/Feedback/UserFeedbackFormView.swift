#if os(iOS)
import OSLog
import SwiftUI


@available(iOS 17, *)
public struct UserFeedbackFormView: View {
	@Environment(\.dismiss) var dismiss

	private enum ViewState {
		case idle
		case sending
		case success
		case failure
	}
	
	private enum FocusedField {
		case email
		case phoneNumber
		case feedback
	}
	
	@State private var email: String = ""
	@State private var phoneNumber: String = ""
	@State private var feedback: String = ""
	@State private var selectedCountryCode: String
	@State private var state = ViewState.idle
	@FocusState private var focusedField: FocusedField?
	
	private let userFeedbackService: UserFeedbackService
	public let configuration: UserFeedbackConfiguration
	private let onCompletion: (() -> Void)?
	
	private var style: FeedbackStyle {
		configuration.feedbackStyle
	}
	
	private var text: FeedbackText {
		configuration.feedbackText
	}
	
	private var isEmailValid: Bool {
		let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
		let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
		return emailTest.evaluate(with: email)
	}

	private var isShowingSuccess: Binding<Bool> {
		Binding(
			get: { state == .success },
			set: { isShowing in if !isShowing { state = .idle } }
		)
	}

	private var isShowingError: Binding<Bool> {
		Binding(
			get: { state == .failure },
			set: { isShowing in if !isShowing { state = .idle } }
		)
	}
	
	public init(
		configuration: UserFeedbackConfiguration,
		userFeedbackService: UserFeedbackService? = nil,
		onCompletion: (() -> Void)? = nil
	) {
		self.configuration = configuration
		self.userFeedbackService = userFeedbackService ?? UserFeedbackService(region: configuration.firebaseRegion)
		self.onCompletion = onCompletion
        let country = Country.local()
        self.selectedCountryCode = country?.code ?? Country.placeholder.code
    }

	public var body: some View {
		VStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 16) {
					Text(LocalizedStrings.feedbackTitle)
                        .font(.system(size: 20, weight: .bold))
						.foregroundColor(style.titlesColor)

					FormField(title: LocalizedStrings.emailTitle, style: style) {
						CustomTextField(
							text: $email,
							focusState: $focusedField,
							focusValue: .email,
							placeholder: LocalizedStrings.emailPlaceholder,
							style: style,
							keyboardType: .emailAddress,
							autocapitalization: .none
						)
					}

					FormField(title: LocalizedStrings.phoneTitle, style: style) {
						HStack(spacing: 12) {
							CountryPicker(
								selectedCountryCode: $selectedCountryCode,
								style: style
							)
							
							CustomTextField(
								text: $phoneNumber,
								focusState: $focusedField,
								focusValue: .phoneNumber,
								placeholder: LocalizedStrings.phonePlaceholder,
								style: style,
								keyboardType: .phonePad,
								autocapitalization: .none
							)
						}
					}

					FormField(title: LocalizedStrings.messageTitle, style: style) {
						CustomTextEditor(
							text: $feedback,
							focusState: $focusedField,
							focusValue: .feedback,
							placeholder: LocalizedStrings.messagePlaceholder,
							style: style,
							minHeight: 120
						)
					}
					Spacer(minLength: 40)
				}
			}
			.scrollDismissesKeyboard(.interactively)
			
			ActionButton(
				text: LocalizedStrings.submitButton,
				style: style,
				isDisabled: email.isEmpty || !isEmailValid || feedback.isEmpty || state == .sending,
				onSubmitAction: onSubmitAction
			)
		}
		.padding()
		.background(style.backgroundColor)
		.onTapGesture {
			focusedField = nil
		}
		.overlay {
			if state == .sending {
				LoadingOverlay(style: style)
			}
		}
		.alert(LocalizedStrings.successTitle, isPresented: isShowingSuccess) {
			Button(LocalizedStrings.successButton) {
				state = .idle
				onCompletion?() ?? dismiss()
			}
		} message: {
			Text(text.successText)
		}
		.alert(LocalizedStrings.errorTitle, isPresented: isShowingError) {
			Button(LocalizedStrings.errorRetryButton) {
				onSubmitAction()
			}
			Button(LocalizedStrings.errorCancelButton, role: .cancel) {
				state = .idle
			}
		} message: {
			Text(LocalizedStrings.errorMessage)
		}
	}
}

@available(iOS 17, *)
extension UserFeedbackFormView {
	func onSubmitAction() {
		guard state != .sending else { return }
		Task {
			await MainActor.run {
				state = .sending
			}
			let country = Country.country(using: selectedCountryCode) ?? Country.placeholder
			let userFeedback = UserFeedback(
				email: email,
				countryCode: country.phoneCode,
				phoneNumber: phoneNumber,
				feedback: feedback
			)
			do {
				try await userFeedbackService.sendFeedback(
					userFeedback: userFeedback,
					metadata: configuration.feedbackMetadata
				)
				await MainActor.run {
					state = .success
				}
			} catch {
				Logger.userFeedback.error("Failed to send founder feedback: \(error.localizedDescription, privacy: .public)")
				await MainActor.run {
					state = .failure
				}
			}
		}
	}
}

@available(iOS 17, *)
private struct LoadingOverlay: View {
	let style: FeedbackStyle
	
	var body: some View {
		ZStack {
			style.backgroundColor.opacity(0.8)
			
			VStack(spacing: 16) {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle(tint: style.textColor))
					.scaleEffect(1.5)
				
				Text(LocalizedStrings.sendingMessage)
					.font(.headline)
					.foregroundColor(style.textColor)
			}
		}
		.ignoresSafeArea()
	}
}
#endif
