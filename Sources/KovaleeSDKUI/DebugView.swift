import KovaleeFramework
import KovaleeSDK
import SwiftUI

@available(iOS 16.0, *)
public struct DebugView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isDebugModeOn = false
    @State private var abTestValue: String?
    @State private var basicInfoExpanded: Bool = false

    private var installationDate: String? {
        guard let installationDate = Kovalee.appInstallationDate() else {
            return nil
        }

        return installationDate.formatted(date: .numeric, time: .omitted)
    }

    public var body: some View {
        NavigationView {
            List {
                Toggle("Enable Debug Mode", isOn: $isDebugModeOn)

                Section {
                    basicInfoView()
                } header: {
                    Text("Basic Infos")
                }

                Section {
                    PurchaseCVView()
                } header: {
                    Text("Purchases")
                }

                Section {
                    InfoLabel(title: "Current AB test Value:", value: abTestValue ?? "Not set yet")
                    if isDebugModeOn {
                        ABTestView()
                    }
                } header: {
                    Text("AB Test")
                }
            }
            .task {
                self.abTestValue = await Kovalee.shared.kovaleeManager?.abTestValue(forKey: "ab_test_version")
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
    private func basicInfoView() -> some View {
        InfoLabel(
            title: "Configuration:",
            value: Kovalee.shared.configuration.environment.rawValue
        )
        InfoLabel(
            title: "SDK Initialized:",
            value: Kovalee.isInitialized ? "✅" : "❌"
        )
        if let installationDate {
            InfoLabel(
                title: "Installation Date",
                value: installationDate
            )
        }
        if let conversionValue = Kovalee.shared.kovaleeManager?.userConversionValue() {
            InfoLabel(
                title: "Conversion Value",
                value: "\(conversionValue)"
            )
        }

        if let userId = Kovalee.getAmplitudeUserId() {
            InfoLabel(
                title: "Amplitude User Id:",
                value: userId,
                horizontal: false
            )
        }
        if let deviceId = Kovalee.shared.kovaleeManager?.amplitudeDeviceId() {
            InfoLabel(
                title: "Amplitude Device Id:",
                value: deviceId,
                horizontal: false
            )
        }
        if let adid = Kovalee.shared.kovaleeManager?.getAttributionAdid() {
            InfoLabel(title: "User ADID:", value: adid, horizontal: false)
        }
    }
}

struct InfoLabel: View {
    var title: String
    var value: String
    var horizontal: Bool = true

    var body: some View {
        if horizontal {
            HStack {
                Text(title).bold()
                Text(value)
            }
        } else {
            VStack(alignment: .leading) {
                Text(title).bold()
                Text(value)
            }
        }
    }
}

@available(iOS 16.0, *)
struct ABTestView: View {
    enum FocusedField {
        case abValue
    }

    @FocusState private var focusedField: FocusedField?
    @State private var newABValue: String = ""

    var body: some View {
        TextField("Set AB test Value", text: $newABValue)
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .abValue)

        Button("Update Value") {
            focusedField = nil
            Kovalee.shared.kovaleeManager?.setAbTestValue(newABValue)
        }
        .buttonStyle(.borderedProminent)
        .onAppear {
            focusedField = .abValue
        }
    }
}

@available(iOS 16.0, *)
struct PurchaseCVView: View {
    @State private var customerSubscriptions: Set<String>?

    var body: some View {
        VStack(alignment: .leading) {
            if let customerSubscriptions {
                Text("Active Subscriptions:").bold()
                ForEach(Array(customerSubscriptions), id: \.self) { subscription in
                    HStack {
                        Text(subscription)
                    }
                }
            } else {
                Text("No Subscriptions purchased")
            }
        }
        .task {
            self.customerSubscriptions = try? await Kovalee.shared.kovaleeManager?.customerInfo()?.activeSubscriptions
        }
    }
}
