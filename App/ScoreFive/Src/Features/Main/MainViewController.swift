//
//  MainViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
import ShortRibs
import SnapKit
import UIKit

/// @mockable
protocol MainViewControllable: ViewControllable {}

/// @mockable
protocol MainPresentableListener: AnyObject {}

final class MainViewController: ScopeViewController, MainPresentable, MainViewControllable {
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundPrimary
    }
    
    // MARK: - MainPresentable
    
    weak var listener: MainPresentableListener?
    
    func showFive(_ viewController: ViewControllable) {
        if fiveViewController != nil {
            removeFiveViewController()
        }
        embedFiveViewController(viewController)
    }
    
    // MARK: - Private
    
    private var fiveViewController: ViewControllable?
    
    private func embedFiveViewController(_ viewController: ViewControllable) {
        assert(fiveViewController == nil)
        addChild(viewController.uiviewController)
        view.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
        }
        viewController.uiviewController.didMove(toParent: self)
        fiveViewController = viewController
    }
    
    private func removeFiveViewController() {
        assert(fiveViewController != nil)
        fiveViewController?.uiviewController.willMove(toParent: self)
        fiveViewController?.uiviewController.view.removeFromSuperview()
        fiveViewController?.uiviewController.removeFromParent()
        fiveViewController = nil
    }
}
