import SwiftUI
import UIKit

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
