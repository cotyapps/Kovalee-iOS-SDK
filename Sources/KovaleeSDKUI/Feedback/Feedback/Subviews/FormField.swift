#if os(iOS)
import SwiftUI

@available(iOS 17, *)
struct FormField<Content: View>: View {
	let title: String
	let style: KovaleeUIStyle

	@ViewBuilder let content: () -> Content
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(title)
				.font(.body).fontWeight(.medium)
				.foregroundColor(style.secondaryColor)
			
			content()
		}
	}
}
#endif
