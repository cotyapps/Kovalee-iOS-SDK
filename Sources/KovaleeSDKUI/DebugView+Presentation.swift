import SwiftUI

public extension View {
    func showDebugMenuOnShake() -> some View {
        modifier(ShakeDetectorModifier())
    }
}

@available(iOS 16.0, *)
public extension UIViewController {
    func presentDebugConsoleOnShake() {
        guard Config.isDebugOrTestflight else {
            return
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(presentSDKDebugConsole),
            name: UIDevice.deviceDidShakeNotification,
            object: nil
        )
    }

    @objc func presentSDKDebugConsole() {
        let debugVC = DebugViewController()
        debugVC.modalPresentationStyle = .fullScreen
        present(debugVC, animated: true, completion: nil)
    }
}
