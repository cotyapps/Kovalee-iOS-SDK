import KovaleeFramework
import KovaleeSDK
import SwiftUI

public struct DebugView: View {
    @State private var abTestValue: String?
    @State private var customerSubscriptions: Set<String>?

    public var body: some View {
        NavigationView {
            List {
                HStack {
                    infoLabel(
                        title: "SDK Initialized:",
                        value: Kovalee.isInitialized ? "✅" : "❌"
                    )
                }
                HStack {
                    infoLabel(
                        title: "Data collection enabled:",
                        value: Kovalee.isDataCollectionEnabled() ? "✅" : "❌"
                    )
                }
                if let userId = Kovalee.getAmplitudeUserId() {
                    infoLabel(
                        title: "Amplitude User Id:",
                        value: userId,
                        horizontal: false
                    )
                }
                if let deviceId = Kovalee.shared.kovaleeManager?.amplitudeDeviceId() {
                    infoLabel(
                        title: "Amplitude Device Id:",
                        value: deviceId,
                        horizontal: false
                    )
                }
                if let adid = Kovalee.shared.kovaleeManager?.getAttributionAdid() {
                    infoLabel(title: "User ADID:", value: adid, horizontal: false)
                }
                if let abTestValue {
                    infoLabel(title: "AB test Value:", value: abTestValue)
                }

                if let customerSubscriptions {
                    VStack(alignment: .leading) {
                        Text("Customer Subscriptions:").bold()
                        ForEach(Array(customerSubscriptions), id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationTitle("SDK Debug View")
            .onAppear {
                Task {
                    self.abTestValue = await Kovalee.shared.kovaleeManager?.abTestValue(forKey: "ab_test_version")
                    self.customerSubscriptions = try? await Kovalee.shared.kovaleeManager?.customerInfo()?.activeSubscriptions
                }
            }
        }
    }

    @ViewBuilder
    func infoLabel(title: String, value: String, horizontal: Bool = true) -> some View {
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

#Preview {
    DebugView()
}
