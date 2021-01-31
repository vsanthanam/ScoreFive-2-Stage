//
//  FiveViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import FiveUI
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
        setUp()
    }

    // MARK: - FivePresentable

    weak var listener: FivePresentableListener?

    func showHome(_ viewController: ViewControllable) {
        embedActiveChild(viewController, with: .pop)
    }

    func showGame(_ viewController: ViewControllable) {
        embedActiveChild(viewController, with: .push)
    }

    // MARK: - Private

    private enum Direction {
        case push
        case pop
    }

    private let nav = UINavigationController()

    private func setUp() {
        addChild(nav)
        view.addSubview(nav.view)
        nav.view.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
        }
        nav.didMove(toParent: self)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundPrimary
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 10 // This is added to the default margin
        appearance.largeTitleTextAttributes = [.paragraphStyle: style]
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.prefersLargeTitles = true
    }

    private func embedActiveChild(_ viewController: ViewControllable, with direction: Direction) {
        guard !nav.viewControllers.contains(viewController.uiviewController) else {
            return
        }
        switch direction {
        case .pop:
            nav.setViewControllers([viewController.uiviewController] + nav.viewControllers, animated: false)
            nav.popToViewController(viewController.uiviewController, animated: true) { [weak nav] in
                guard let nav = nav else {
                    assertionFailure("Managed Navigation Controller OOM")
                    return
                }
                assert(nav.viewControllers.count == 1, "Invalid View Controller Count")
            }
        case .push:
            nav.pushViewController(viewController: viewController.uiviewController, animated: true) { [weak nav] in
                guard let nav = nav else {
                    assertionFailure("Managed Navigation Controller OOM")
                    return
                }
                nav.viewControllers = [viewController.uiviewController]
            }
        }
    }
}
