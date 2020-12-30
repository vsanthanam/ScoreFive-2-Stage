//
//  GameViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol GameViewControllable: ViewControllable {}

/// @mockable
protocol GamePresentableListener: AnyObject {}

final class GameViewController: ScopeViewController, GamePresentable, GameViewControllable {
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - GamePresentable
    
    weak var listener: GamePresentableListener?
    
    func showNewRound(_ viewController: ViewControllable) {
        confineTo(viewEvents: [.viewDidAppear], once: true) {
            if let current = self.newRoundViewController {
                current.uiviewController.dismiss(animated: true) { [weak self] in
                    self?.newRoundViewController = nil
                    self?.showNewRound(viewController)
                }
            } else {
                self.present(viewController.uiviewController, animated: true) { [weak self] in
                    self?.newRoundViewController = viewController
                }
            }
        }
    }
    
    func closeNewRound() {
        newRoundViewController?.uiviewController.dismiss(animated: true, completion: nil)
    }
    
    func showScoreCard(_ viewController: ScoreCardViewControllable) {
        if let current = scoreCardViewController {
            current.uiviewController.willMove(toParent: nil)
            current.uiviewController.view.removeFromSuperview()
            current.uiviewController.removeFromParent()
            scoreCardViewController = nil
        }
        addChild(viewController.uiviewController)
        view.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.snp.makeConstraints { make in
            make
                .edges
                .equalTo(scoreCardLayoutGuide)
        }
        viewController.uiviewController.didMove(toParent: self)
    }
    
    // MARK: - Private
    
    private let scoreCardLayoutGuide = UILayoutGuide()
    
    private var newRoundViewController: ViewControllable?
    private var scoreCardViewController: ScoreCardViewControllable?
    
    private func setUp() {
        view.backgroundColor = .backgroundSecondary
        view.addLayoutGuide(scoreCardLayoutGuide)
        scoreCardLayoutGuide.snp.makeConstraints { make in
            make
                .edges
                .equalTo(view.safeAreaLayoutGuide)
                .inset(20.0)
        }
    }
}
