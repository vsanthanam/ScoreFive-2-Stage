//
//  FiveViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol FiveViewControllable: ViewControllable {}

/// @mockable
protocol FivePresentableListener: AnyObject {}

final class FiveViewController: ScopeViewController, FivePresentable, FiveViewControllable {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundPrimary
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        activeChild?.uiviewController.preferredStatusBarStyle ?? .default
    }

    // MARK: - FivePresentable

    weak var listener: FivePresentableListener?

    func showHome(_ viewController: ViewControllable) {
        removeActiveChild()
        embedActiveChild(viewController)
    }

    func showGame(_ viewController: ViewControllable) {
        removeActiveChild()
        embedActiveChild(viewController)
    }

    // MARK: - Private

    private var activeChild: ViewControllable? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    private func embedActiveChild(_ viewController: ViewControllable) {
        addChild(viewController.uiviewController)
        view.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
        }
        viewController.uiviewController.didMove(toParent: self)
        activeChild = viewController
    }

    private func removeActiveChild() {
        activeChild?.uiviewController.willMove(toParent: nil)
        activeChild?.uiviewController.view.removeFromSuperview()
        activeChild?.uiviewController.removeFromParent()
        activeChild = nil
    }
}
