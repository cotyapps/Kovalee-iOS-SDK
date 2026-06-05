#if os(iOS)
import SwiftUI

@available(iOS 17, *)
struct ActionButton: View {
	let text: String
	let style: FeedbackStyle
	let isDisabled: Bool
	let onSubmitAction: () -> Void
    let symbol: String?

	private var adaptiveTextColor: Color {
		let backgroundColor = isDisabled ? style.fieldBackgroundColor : style.submitButtonColor
		return backgroundColor.isLight ? .black : .white
	}

    init(text: String, symbol: String? = nil, style: FeedbackStyle, isDisabled: Bool, onSubmitAction: @escaping () -> Void) {
        self.text = text
        self.style = style
        self.isDisabled = isDisabled
        self.onSubmitAction = onSubmitAction
        self.symbol = symbol
    }
    
	var body: some View {
		Button(action: onSubmitAction) {
            HStack {
                Spacer()
                if let symbol = symbol {
                    Image(systemName: symbol)
                        .foregroundColor(isDisabled ? adaptiveTextColor.opacity(0.4) : adaptiveTextColor)
                        .padding(.horizontal, 16)
                }
                Text(text)
                    .font(.headline).fontWeight(.semibold)
                    .foregroundColor(isDisabled ? adaptiveTextColor.opacity(0.4) : adaptiveTextColor)
                Spacer()
            }
            .padding(.vertical, 16)
            .background(isDisabled ? style.fieldBackgroundColor : style.submitButtonColor)
            .cornerRadius(25)
		}
		.disabled(isDisabled)
		
	}
}

@available(iOS 17, *)
extension Color {
	var isLight: Bool {
		let uiColor = UIColor(self)
		var white: CGFloat = 0
		uiColor.getWhite(&white, alpha: nil)
		return white > 0.5
	}
}
#endif
