import SwiftUI

/// To integrate ``DebugView`` into your SwiftUI-based projects you should use the view modifier ``showDebugConsoleOnShake()``.
/// This method ensures that the debug console is only presented in debug builds or TestFlight builds.
///
/// ### Usage
///
/// Integrate ``DebugView`` in your view controller as follows:
///
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
///	```
public extension View {
    func showDebugConsoleOnShake() -> some View {
        modifier(ShakeDetectorModifier())
    }
}

/// To display ``DebugView`` into your UIKit-based projects, we recommend using the provided method ``presentDebugConsoleOnShake()``. This function will present ``DebugViewController`` which is a UIKit wrapper around ``DebugView``.
/// This method ensures that the debug console is only presented in debug builds or TestFlight builds.
///
/// ### Usage
///
/// Integrate ``DebugViewController`` in your view controller as follows:
///
/// ```
/// class YourViewController: UIViewController {
/// 	override func viewDidLoad() {
///	   		super.viewDidLoad()
///			presentDebugConsoleOnShake()
///		}
///	}
/// ```
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
