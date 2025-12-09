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
                Text("SDK Version: \(SDK_VERSION)")
                    .allowsHitTesting(false)
                Toggle("Enable Debug Mode", isOn: $isDebugModeOn)

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

                Section {
                    deepLinkView
                } header: {
                    Text("DeepLink")
                }

                Section {
                    InfoLabel(title: "Current AB test Value:", value: abTestValue ?? "Not set yet")
                        .allowsHitTesting(false)
                    if isDebugModeOn {
                        ABTestView()
                    }
                } header: {
                    Text("AB Test")
                }
            }
            .allowsHitTesting(true)
            .task {
                self.abTestValue = await Kovalee.shared.kovaleeManager?.abTestValue(forKey: "ab_test_version")
                self.adid = await Kovalee.shared.kovaleeManager?.getAttributionAdid()

                self.conversionValue = fetchConversionValue()
                self.coarseValue = fetchCoarseValue()
                self.installationDate = fetchInstallationDate()
                self.sessionCount = fetchSessionCount()
                self.lastDeeplinkReceived = fetchLastOpenedURL()
            }
            .navigationTitle("SDK Debug Console")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: isDebugModeOn) { _ in
                Kovalee.shared.kovaleeManager?.setDebugMode(isDebugModeOn)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "xmark", role: .destructive) {
                        dismiss()
                    }
                    .bold()
                    .tint(.black)
                }
            }
        }
    }
}

@available(iOS 16.0, *)
extension DebugView {
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
                title: "Last opened URL:",
                value: lastDeeplinkReceived,
                horizontal: false,
                allowCopy: true
            )
            if let parsingError = deepLinkParsingError() {
                InfoLabel(
                    title: "Error:",
                    value: parsingError
                )
            }
        } else {
            Text("No deeplinks opened yet")
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
