import SwiftUI

struct InfoLabel: View {
    var title: String
    var value: String
    var horizontal: Bool = true
    var allowCopy: Bool = false

    var body: some View {
        if horizontal {
            HStack {
                Text(title).bold()
                Text(value)
                if allowCopy {
                    copyButton
                }
            }
        } else {
            VStack(alignment: .leading) {
                Text(title).bold()
                HStack {
                    Text(value)
                    if allowCopy {
                        copyButton
                    }
                }
            }
        }
    }

    var copyButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            UIPasteboard.general.string = value
        }) {
            Image(systemName: "document.on.document")
        }
    }
}
