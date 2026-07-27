#if os(iOS)
    import KovaleeSDK
    import SwiftUI

    /// Debug-menu section showing the live status of the optional ad-SDK modules
    /// (TikTok): linked or not, configuration, consent/activation state,
    /// plus test-event and flush actions to exercise the pipeline end-to-end.
    ///
    /// Cards come from ``KovaleeDebugIntegrations``, which each optional module
    /// populates when its `Creator` runs — so "Not linked" means the module was
    /// never compiled into the app, not merely misconfigured.
    @available(iOS 16.0, *)
    struct AdSDKIntegrationsView: View {
        private struct Slot {
            let id: String
            let title: String
            /// Info.plist key whose presence hints at a half-finished setup when
            /// the module itself is not linked.
            let plistHintKey: String?
        }

        private static let slots: [Slot] = [
            Slot(id: "tiktok", title: "TikTok", plistHintKey: nil),
        ]

        /// Transient per-card confirmation after an action button ran.
        @State private var feedback: [String: String] = [:]

        var body: some View {
            ForEach(Self.slots, id: \.id) { slot in
                if let integration = KovaleeDebugIntegrations.shared.integration(withId: slot.id) {
                    linkedCard(integration)
                } else {
                    notLinkedRow(slot)
                }
            }
        }

        @ViewBuilder
        private func linkedCard(_ integration: KovaleeDebugIntegration) -> some View {
            DisclosureGroup {
                ForEach(integration.fields(), id: \.label) { field in
                    InfoLabel(title: field.label, value: field.value)
                }
                HStack(spacing: 10) {
                    ForEach(integration.actions, id: \.label) { action in
                        Button(action.label) {
                            action.run()
                            feedback[integration.id] = "\(action.label) — done, check the console / network"
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                }
                if let note = feedback[integration.id] {
                    Text(note)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            } label: {
                HStack {
                    Text(integration.title)
                    Spacer()
                    Text("Linked")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.green)
                }
            }
        }

        @ViewBuilder
        private func notLinkedRow(_ slot: Slot) -> some View {
            VStack(alignment: .leading, spacing: 4) {
                InfoLabel(title: slot.title, value: "Not linked")
                if let key = slot.plistHintKey,
                   Bundle.main.object(forInfoDictionaryKey: key) != nil {
                    Text("Info.plist defines \(key) but the Kovalee module isn't linked — the Kovalee SDK is not sending events to this network.")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }
        }
    }
#endif
