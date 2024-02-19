import SwiftUI
import UIKit

public extension View {
    func showDebugMenuOnShake() -> some View {
        modifier(ShakeDetectorModifier())
    }
}

struct ShakeDetectorModifier: ViewModifier {
    @State private var isDebugViewPresented = false

    func body(content: Content) -> some View {
        content
            .onShake {
                self.isDebugViewPresented = true
            }
            .sheet(isPresented: $isDebugViewPresented) {
                if #available(iOS 16.0, *) {
                    DebugView()
                } else {
                    Text("Debug view is supported in iOS 16+")
                }
            }
    }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(DeviceShakeViewModifier(action: action))
    }
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with _: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}
