#if os(iOS)
import SwiftUI

@available(iOS 17, *)
struct FeedbackDebugView: View {
    @State private var coordinator = FeedbackCoordinator()

    var body: some View {
        VStack(spacing: 10) {
            Button {
                coordinator.showFounder()
            } label: {
                Label("Preview Founder Feedback", systemImage: "eye")
            }
            .buttonStyle(.debugPrimary)

            Button {
                coordinator.showFeatures()
            } label: {
                Label("Preview Feature Survey", systemImage: "eye")
            }
            .buttonStyle(.debugSecondary)
        }
        .userFeedback(coordinator: coordinator)
    }
}
#endif
