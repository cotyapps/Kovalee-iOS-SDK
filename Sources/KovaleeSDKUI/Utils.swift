import SwiftUI
import UIKit

struct ShakeDetectorModifier: ViewModifier {
    @State private var isDebugViewPresented = false

    func body(content: Content) -> some View {
        content
            .onShake {
                guard Config.isDebugOrTestflight else {
                    return
                }
                self.isDebugViewPresented = true
            }
            .fullScreenCover(isPresented: $isDebugViewPresented) {
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

public extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with _: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

enum Config {
    enum AppConfiguration {
        case Debug
        case TestFlight
        case AppStore
    }

    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static var appConfiguration: AppConfiguration {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }

    static var isDebugOrTestflight: Bool {
        if isDebug || isTestFlight {
            return true
        } else {
            return false
        }
    }
}
