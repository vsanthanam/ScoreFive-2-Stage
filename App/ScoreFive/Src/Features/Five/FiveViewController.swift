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

final class FiveViewController: ScopeViewController, FivePresentable, FiveViewControllable, UINavigationBarDelegate {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        activeChild?.uiviewController.preferredStatusBarStyle ?? .default
    }

    // MARK: - FivePresentable

    weak var listener: FivePresentableListener?

    func showHome(_ viewController: FiveStateViewControllable) {
        removeActiveChild()
        embedActiveChild(viewController)
    }

    func showGame(_ viewController: FiveStateViewControllable) {
        removeActiveChild()
        embedActiveChild(viewController)
    }
    
    // MARK: - UINavigationBarDelegate
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }

    // MARK: - Private
    
    private let navigationBar: UINavigationBar = .init(frame: .zero)

    private func setUp() {
        specializedView.backgroundColor = .backgroundPrimary
        specializedView.addSubview(navigationBar)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundPrimary
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 10 // This is added to the default margin
        appearance.largeTitleTextAttributes = [.paragraphStyle: style]
        navigationBar.standardAppearance = appearance
        navigationBar.delegate = self
        navigationBar.snp.makeConstraints { make in
            make
                .top
                .equalTo(specializedView.safeAreaLayoutGuide)
            make
                .leading
                .trailing
                .equalToSuperview()
        }
    }
    
    private var activeChild: ViewControllable? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    private func embedActiveChild(_ viewController: FiveStateViewControllable) {
        addChild(viewController.uiviewController)
        view.addSubview(viewController.uiviewController.view)
        let navigationItem = UINavigationItem(title: viewController.headerTitle)
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItems = viewController.leadingActions
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.prefersLargeTitles = viewController.largeTitles
        viewController.uiviewController.view.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .bottom
                .equalToSuperview()
            make
                .top
                .equalTo(navigationBar.snp.bottom)
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
