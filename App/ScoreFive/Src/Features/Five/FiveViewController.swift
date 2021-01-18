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
        setUp()
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
    }
    
    private func embedActiveChild(_ viewController: ViewControllable) {
        nav.setViewControllers([viewController.uiviewController], animated: true)
        nav.view.setNeedsLayout()
    }

    private func removeActiveChild() {
        navigationController?.viewControllers = []
        nav.view.setNeedsLayout()
    }
}
