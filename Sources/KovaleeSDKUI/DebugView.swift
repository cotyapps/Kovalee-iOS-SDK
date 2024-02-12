import KovaleeFramework
import KovaleeSDK
import SwiftUI

@available(iOS 16.0, *)
public struct DebugView: View {
    @State private var isDebugModeOn = false

    var installationDate: String? {
        guard let installationDate = Kovalee.appInstallationDate() else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: installationDate)
    }

    public var body: some View {
        NavigationView {
            List {
                Toggle("Enable Debug Mode", isOn: $isDebugModeOn)

                Section {
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

                Section {
                    ABTestView()
                }

//                Section {
//                    PurchaseCVView()
//                }
            }
            .navigationTitle("SDK Debug Console")
            .onChange(of: isDebugModeOn) { _ in
                Kovalee.shared.kovaleeManager?.setDebugMode(isDebugModeOn)
            }
        }
    }
}

@available(iOS 16.0, *)
#Preview {
    DebugView()
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
    @State private var abTestValue: String?
    @State private var newABValue: String = ""

    var body: some View {
        Group {
            if let abTestValue {
                InfoLabel(title: "Current AB test Value:", value: abTestValue)
            }
            TextField("Set AB test Value", text: $newABValue)
                .keyboardType(.numberPad)

            Button("Update Value") {
                Kovalee.shared.kovaleeManager?.setAbTestValue(newABValue)
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            Task {
                self.abTestValue = await Kovalee.shared.kovaleeManager?.abTestValue(forKey: "ab_test_version")
            }
        }
    }
}

@available(iOS 16.0, *)
struct PurchaseCVView: View {
    @State private var customerSubscriptions: Set<String>?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Customer Subscriptions:").bold()
            if let customerSubscriptions {
                ForEach(Array(customerSubscriptions), id: \.self) { subscription in
                    HStack {
                        Text(subscription)
                    }
                }
            }
        }
        .task {
            self.customerSubscriptions = try? await Kovalee.shared.kovaleeManager?.customerInfo()?.activeSubscriptions
        }
    }
}
