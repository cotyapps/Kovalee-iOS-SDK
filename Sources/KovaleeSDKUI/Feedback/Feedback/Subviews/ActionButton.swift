#if os(iOS)
import SwiftUI
import UIKit

@available(iOS 17, *)
struct ActionButton: View {
	let text: String
	let style: FeedbackStyle
	let isDisabled: Bool
	let onSubmitAction: () -> Void
    let symbol: String?

	private var adaptiveTextColor: Color {
		let backgroundColor = isDisabled ? style.secondaryBackgroundColor : style.ctaColor
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
            .background(isDisabled ? style.secondaryBackgroundColor : style.ctaColor)
            .cornerRadius(25)
		}
		.disabled(isDisabled)
		
	}
}

@available(iOS 17, *)
extension Color {
	var isLight: Bool {
		let uiColor = UIColor(self).resolvedColor(with: UITraitCollection.current)
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
			let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
			return luminance > 0.5
		}
		var white: CGFloat = 0
		if uiColor.getWhite(&white, alpha: &alpha) {
			return white > 0.5
		}
		return true
	}
}
#endif
