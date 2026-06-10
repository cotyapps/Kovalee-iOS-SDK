#if os(iOS)
    import KovaleeFramework
    import KovaleeSDK
    import SwiftUI

    /// `DebugView` is designed to display and interact with the information collected by the SDK.
    ///
    /// Use `DebugView` to present critical debugging information such as:
    /// - installation date
    /// - Current Conversion Value
    /// - Amplitude user ID
    /// - Amplitude device ID
    /// - adid
    /// - Current A/B test variant
    /// - Purchased products.
    /// This view also allows to force a specific A/B test variant.
    ///
    /// - Important: ``DebugView`` is not intended for use in production.
    ///
    /// ## Integration
    /// You can integrated ``DebugView`` in your code as you would integrate any other view.
    ///
    /// We strongly encourage you to use the provided utilities to present ``DebugView``.
    ///
    /// ### SwiftUI
    /// If your project uses SwiftUI you should use the view modifier ``showDebugConsoleOnShake()`` as follows:
    /// ```swift
    /// @main
    /// struct NewApp: App {
    ///	    var body: some Scene {
    ///	        WindowGroup {
    ///				ContentView()
    ///					.showDebugConsoleOnShake()
    ///	 		}
    ///		}
    ///	}
    /// ```
    /// ``showDebugConsoleOnShake()`` will take care of only showing the debug console in a debug build or a test flight build.
    @available(iOS 16.0, *)
    public struct DebugView: View {
        @Environment(\.dismiss) private var dismiss

        @State private var isDebugModeOn = false
        @State private var abTestValue: String?
        @State private var adid: String?
        @State private var basicInfoExpanded: Bool = false

        @State private var coarseValue: String?
        @State private var conversionValue: Int?
        @State private var installationDate: String?
        @State private var sessionCount: Int?
        @State private var lastDeeplinkReceived: String?

        public init() {}

        public var body: some View {
            NavigationView {
                List {
                    Section {
                        InfoLabel(title: "Framework", value: KovaleeBuildInfo.commit)
                        InfoLabel(title: "Built", value: KovaleeBuildInfo.builtAt)
                    } header: {
                        Text("Build Info")
                    }

                    Section {
                        InfoLabel(title: "Current Value", value: abTestValue ?? "Not set yet")
                            .allowsHitTesting(false)
                        if isDebugModeOn {
                            ABTestView()
                        }
                    } header: {
                        Text("AB Test")
                    }

                    Section {
                        basicInfoView
                    } header: {
                        Text("Basic Infos")
                    }

                    Section {
                        conversionValueView
                    } header: {
                        Text("Conversion Value")
                    }

                    Section {
                        EventsSequencesConfigurationView(isDebugModeOn: $isDebugModeOn)
                    } header: {
                        Text("Events Sequences")
                    }

                    Section {
                        PurchaseCVView()
                    } header: {
                        Text("Purchases")
                    }

                    if isDebugModeOn {
                        Section {
                            SubscriptionUpsellDebugView()
                        } header: {
                            Text("Subscription Upsell")
                        } footer: {
                            Text("Tools to test and manage the subscription upsell experience.")
                        }

                        if #available(iOS 17, *) {
                            Section {
                                FeedbackDebugView()
                            } header: {
                                Text("In-App Feedback")
                            } footer: {
                                Text("Preview and test in-app feedback flows.")
                            }
                        }
                    }

                    Section {
                        deepLinkView
                    } header: {
                        Text("DeepLink")
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))
                .toolbar(.hidden, for: .navigationBar)
                .safeAreaInset(edge: .top, spacing: 0) {
                    debugHeader
                }
                .safeAreaInset(edge: .bottom) {
                    debugModeFloatingBar
                }
                .task {
                    self.abTestValue = await Kovalee.shared.kovaleeManager?.abTestValue(forKey: Kovalee.abTestKey)
                    self.adid = await Kovalee.shared.kovaleeManager?.getAttributionAdid()

                    self.conversionValue = fetchConversionValue()
                    self.coarseValue = fetchCoarseValue()
                    self.installationDate = fetchInstallationDate()
                    self.sessionCount = fetchSessionCount()
                    self.lastDeeplinkReceived = fetchLastOpenedURL()
                }
                .onChange(of: isDebugModeOn) { _ in
                    Kovalee.shared.kovaleeManager?.setDebugMode(isDebugModeOn)
                }
            }
            .navigationViewStyle(.stack)
        }
    }

    @available(iOS 16.0, *)
    extension DebugView {
        private var debugHeader: some View {
            HStack(spacing: 12) {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.debugAccent)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.debugAccent.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("Debug Console")
                        .font(.title3.bold())
                    Text("Kovalee SDK · v\(SDK_VERSION)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                        .debugGlassCircle()
                }
                .accessibilityLabel("Close")
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 12)
            .background(Color(.systemGroupedBackground))
        }

        private var debugModeFloatingBar: some View {
            HStack(spacing: 14) {
                Image(systemName: isDebugModeOn ? "ladybug.fill" : "ladybug")
                    .font(.system(size: 22))
                    .foregroundStyle(isDebugModeOn ? .green : .secondary)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Enable Debug Mode")
                        .font(.body.weight(.semibold))
                    Text("Enables developer tools and options.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                Toggle("Enable Debug Mode", isOn: $isDebugModeOn)
                    .labelsHidden()
                    .tint(.green)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 6)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }

        @ViewBuilder
        private var basicInfoView: some View {
            InfoLabel(
                title: "Configuration:",
                value: Kovalee.shared.configuration.environment.rawValue
            )
            InfoLabel(
                title: "SDK Initialized:",
                value: Kovalee.isInitialized ? "✅" : "❌"
            )
            if let locale = Locale.current.region?.identifier {
                InfoLabel(
                    title: "Current Locale:",
                    value: locale
                )
            }

            if let installationDate {
                InfoLabel(
                    title: "Installation Date:",
                    value: installationDate
                )
            }
            if let sessionCount {
                InfoLabel(
                    title: "Session Count:",
                    value: "\(sessionCount)"
                )
            }
            if let userId = Kovalee.getAmplitudeUserId() {
                InfoLabel(
                    title: "Amplitude User Id:",
                    value: userId,
                    horizontal: false,
                    allowCopy: true
                )
            }
            if let deviceId = Kovalee.shared.kovaleeManager?.amplitudeDeviceId() {
                InfoLabel(
                    title: "Amplitude Device Id:",
                    value: deviceId,
                    horizontal: false,
                    allowCopy: true
                )
            }
            if let adid {
                InfoLabel(
                    title: "User ADID:",
                    value: adid,
                    horizontal: false,
                    allowCopy: true
                )
            }


        }

        @ViewBuilder
        private var conversionValueView: some View {
            if let conversionValue {
                InfoLabel(
                    title: "Conversion Value:",
                    value: "\(conversionValue)"
                )
            }
            if let coarseValue {
                InfoLabel(
                    title: "Coarse Value",
                    value: "\(coarseValue)"
                )
            }
        }

        @ViewBuilder
        private var deepLinkView: some View {
            if let lastDeeplinkReceived {
                InfoLabel(
                    title: "Last opened URL",
                    value: lastDeeplinkReceived,
                    horizontal: false,
                    allowCopy: true
                )
                if let parsingError = deepLinkParsingError() {
                    InfoLabel(
                        title: "Error",
                        value: parsingError
                    )
                }
            } else {
                HStack(spacing: 14) {
                    Image(systemName: "link")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.debugAccent)
                        .frame(width: 30)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("No deeplinks opened yet")
                            .font(.body.weight(.medium))
                        Text("Open a supported link to see details here.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    @available(iOS 16.0, *)
    extension DebugView {
        private func fetchInstallationDate() -> String? {
            guard let installationDate = Kovalee.appInstallationDate() else {
                return nil
            }

            return installationDate.formatted(date: .numeric, time: .omitted)
        }

        private func fetchCoarseValue() -> String? {
            Kovalee.shared.kovaleeManager?.userCoarseValue()
        }

        private func fetchConversionValue() -> Int? {
            Kovalee.shared.kovaleeManager?.userConversionValue()
        }

        private func fetchSessionCount() -> Int? {
            Kovalee.shared.kovaleeManager?.appOpeningCount()
        }

        private func fetchLastOpenedURL() -> String? {
            Kovalee.shared.kovaleeManager?.lastOpenedUrlValue()
        }

        private func deepLinkParsingError() -> String? {
            Kovalee.shared.kovaleeManager?.deepLinkParsingErrorValue()
        }
    }
#endif
