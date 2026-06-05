#if os(iOS)
import SwiftUI

@available(iOS 17, *)
struct LoaderOverlay: View {
    let primaryColor: Color
    let backgroundColor: Color

    var body: some View {
        ZStack {
            backgroundColor.opacity(0.8)
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: primaryColor))
                    .scaleEffect(1.5)

                Text(LocalizedStrings.sendingMessage)
                    .font(.headline)
                    .foregroundColor(primaryColor)
            }
        }
        .ignoresSafeArea()
    }
}
#endif
