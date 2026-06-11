#if os(iOS)
    import SwiftUI

    extension Color {
        /// Accent used across the debug console UI.
        static let debugAccent = Color(red: 0.36, green: 0.24, blue: 0.96)
    }

    /// Full-width button used throughout the debug console.
    ///
    /// - `.primary` renders a filled accent button with white content.
    /// - `.secondary` renders an outlined button with accent content.
    @available(iOS 15.0, *)
    struct DebugButtonStyle: ButtonStyle {
        enum Kind {
            case primary
            case secondary
        }

        var kind: Kind = .primary

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .foregroundStyle(kind == .primary ? Color.white : Color.debugAccent)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(kind == .primary ? Color.debugAccent : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.debugAccent, lineWidth: kind == .secondary ? 1.5 : 0)
                )
                .opacity(configuration.isPressed ? 0.75 : 1)
                .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
        }
    }

    @available(iOS 15.0, *)
    extension ButtonStyle where Self == DebugButtonStyle {
        static var debugPrimary: DebugButtonStyle { DebugButtonStyle(kind: .primary) }
        static var debugSecondary: DebugButtonStyle { DebugButtonStyle(kind: .secondary) }
    }

    extension View {
        /// Applies an interactive circular Liquid Glass background on iOS 26+,
        /// falling back to a tinted system fill on earlier versions.
        @ViewBuilder
        func debugGlassCircle() -> some View {
            if #available(iOS 26.0, *) {
                glassEffect(.regular.interactive(), in: .circle)
            } else {
                background(Circle().fill(Color(.tertiarySystemFill)))
            }
        }
    }
#endif
