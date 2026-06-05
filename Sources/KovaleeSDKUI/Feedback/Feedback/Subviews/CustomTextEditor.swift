#if os(iOS)
import SwiftUI

@available(iOS 17, *)
struct CustomTextEditor<FocusValue: Hashable>: View {
	@Binding var text: String
	var focusState: FocusState<FocusValue?>.Binding?
	var focusValue: FocusValue?

	let placeholder: String
	let style: FeedbackStyle
	let minHeight: CGFloat
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			TextEditor(text: $text)
				.font(.body)
				.foregroundColor(style.textColor)
				.scrollContentBackground(.hidden)
				.background(style.fieldBackgroundColor)
				.cornerRadius(8)
				.frame(minHeight: minHeight)
				.focused(focusState ?? FocusState<FocusValue?>().projectedValue, equals: focusValue)
			
			if text.isEmpty {
				Text(placeholder)
					.font(.body)
					.foregroundColor(style.textColor.opacity(0.6))
					.padding(.horizontal, 8)
					.padding(.vertical, 8)
					.allowsHitTesting(false)
			}
		}
		.background(style.fieldBackgroundColor)
		.cornerRadius(8)
	}
}
#endif
