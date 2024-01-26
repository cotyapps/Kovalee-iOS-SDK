import KovaleeFramework
import KovaleeSDK
import SwiftUI

public struct DebugView: View {
    @State private var abTestValue: String?
    @State private var customerInfo: String?

    public var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("SDK Initialized: \(Kovalee.isInitialized ? "✅" : "❌")")
                Text("Data collection enabled: \(Kovalee.isDataCollectionEnabled() ? "✅" : "❌")")
                if let userId = Kovalee.getAmplitudeUserId() {
                    Text("Amplitude User Id: \(userId)")
                }
                if let deviceId = Kovalee.shared.kovaleeManager?.amplitudeDeviceId() {
                    Text("Amplitude Device Id: \(deviceId)")
                }
                if let adid = Kovalee.shared.kovaleeManager?.getAttributionAdid() {
                    Text("User ADID: \(adid)")
                }
                if let abTestValue {
                    Text("AB test Value: \(abTestValue)")
                }

                if let customerInfo {
                    Text("CustomerInfo: \(customerInfo)")
                }
            }
            .navigationTitle("SDK Debug View")
            .onAppear {
                Task {
                    self.abTestValue = await Kovalee.shared.kovaleeManager?.abTestValue(forKey: "ab_test_version")
                    self.customerInfo = try? await Kovalee.shared.kovaleeManager?.customerInfo().debugDescription
                }
            }
        }
    }
}

#Preview {
    DebugView()
}
