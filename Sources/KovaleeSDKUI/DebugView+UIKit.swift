import SwiftUI
import UIKit

/// ``DebugViewController`` is a UIKit wrapper around the SwiftUI ``DebugView``.
///
/// This controller facilitates the integration of ``DebugView`` in UIKit-based applications.
/// It provides an easy way to present critical debugging information.
/// The information displayed includes:
/// - installation date,
/// - current conversion value
/// - user IDs
/// - A/B test variants
/// - purchased products.
/// This controller also allows for the manipulation of A/B test variants.
///
/// - Important: ``DebugViewController`` is not intended for use in production.
///
/// ## Integration
/// Integrate ``DebugViewController`` into your UIKit-based projects to display ``DebugView``.
///
/// We recommend using the provided method ``presentDebugConsoleOnShake()`` to present ``DebugViewController``.
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
public class DebugViewController: UIViewController {
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let debugVC = UIHostingController(rootView: DebugView())
        let swiftuiView = debugVC.view!
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        addChild(debugVC)
        view.addSubview(swiftuiView)

        NSLayoutConstraint.activate([
            swiftuiView.topAnchor.constraint(equalTo: view.topAnchor),
            swiftuiView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            swiftuiView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            swiftuiView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        debugVC.didMove(toParent: self)
    }
}
