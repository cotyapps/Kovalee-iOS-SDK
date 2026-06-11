#if os(iOS)
    import SwiftUI

    @available(iOS 16.0, *)
    struct InfoLabel: View {
        var title: String
        var value: String
        var horizontal: Bool = true
        var allowCopy: Bool = false

        var body: some View {
            if horizontal {
                LabeledContent(title, value: value)
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 6) {
                        Text(value)
                            .font(.system(.subheadline, design: .monospaced))
                            .textSelection(.enabled)
                        if allowCopy {
                            copyButton
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }

        private var copyButton: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                UIPasteboard.general.string = value
            } label: {
                Image(systemName: "document.on.document")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
#endif
