//
//  HomeViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import FiveUI
import Foundation
import ScoreKeeping
import ShortRibs
import UIKit

/// @mockable
protocol HomeViewControllable: ViewControllable {}

/// @mockable
protocol HomePresentableListener: AnyObject {}

final class HomeViewController: ScopeViewController, HomePresentable, HomeViewControllable {
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundPrimary
    }
    
    // MARK: - HomePresentable
    
    weak var listener: HomePresentableListener?
    
    func showNewGame(_ viewController: ViewControllable) {
        confineTo(viewEvents: [.viewDidAppear], once: true) {
            if let current = self.newGameViewController {
                current.uiviewController.dismiss(animated: true) { [weak self] in
                    self?.newGameViewController = nil
                    self?.showNewGame(viewController)
                }
            } else {
                self.present(viewController.uiviewController, animated: true) { [weak self] in
                    self?.newGameViewController = viewController
                }
            }
        }
    }
    
    func closeNewGame() {
        newGameViewController?.uiviewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private var newGameViewController: ViewControllable?
}
