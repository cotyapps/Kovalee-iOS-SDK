#if os(iOS) || os(visionOS)
    import SwiftUI

    @available(iOS 16.0, *)
    struct InfoLabel: View {
        var title: String
        var value: String
        var horizontal: Bool = true
        var allowShare: Bool = false

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
                        if allowShare {
                            shareButton
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }

        private var shareButton: some View {
            ShareLink(item: value, subject: Text(title)) {
                Image(systemName: "square.and.arrow.up")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
#endif
