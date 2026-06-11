#if os(iOS)
import SwiftUI

@available(iOS 17, *)
struct CustomTextField<FocusValue: Hashable>: View {
	@Binding var text: String
	var focusState: FocusState<FocusValue?>.Binding?
	var focusValue: FocusValue?

	let placeholder: String
	let style: FeedbackStyle
	let keyboardType: UIKeyboardType
	let autocapitalization: UITextAutocapitalizationType
	
	var body: some View {
		TextField(
			"",
			text: $text,
			prompt: Text(placeholder)
				.foregroundColor(style.secondaryColor.opacity(0.6))
		)
		.font(.body)
		.foregroundColor(style.secondaryColor)
		.padding(.horizontal, 12)
		.padding(.vertical, 12)
		.background(style.secondaryBackgroundColor)
		.cornerRadius(8)
		.keyboardType(keyboardType)
		.autocapitalization(autocapitalization)
		.focused(focusState ?? FocusState<FocusValue?>().projectedValue, equals: focusValue)
	}
}
#endif
