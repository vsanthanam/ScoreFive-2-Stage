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
protocol GamePresentableListener: AnyObject {
    func wantNewRound()
}

final class GameViewController: ScopeViewController, GamePresentable, GameViewControllable {
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return .darkContent
        case .light, .unspecified:
            return .lightContent
        @unknown default:
            return .lightContent
        }
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
    
    func updateHeaderTitles(_ titles: [String]) {
        gameHeader.apply(names: titles)
    }
    
    func updateTotalScores(_ scores: [String]) {
        gameFooter.apply(scores: scores)
    }
    
    // MARK: - Private
    
    private let topSpacer = ScopeView()
    private let bottomSpacer = ScopeView()
    private let gameHeader = GameHeaderView()
    private let gameFooter = GameFooterView()
    private let addRoundButton = AddRoundButton()
    private let scoreCardLayoutGuide = UILayoutGuide()
    
    private var newRoundViewController: ViewControllable?
    private var scoreCardViewController: ScoreCardViewControllable?
    
    private func setUp() {
        view.addLayoutGuide(scoreCardLayoutGuide)
        
        topSpacer.backgroundColor = .backgroundInversePrimary
        specializedView.addSubview(topSpacer)
        
        addRoundButton.addTarget(self, action: #selector(didTapAddRound), for: .touchUpInside)
        specializedView.addSubview(addRoundButton)
        
        bottomSpacer.backgroundColor = .contentAccentPrimary
        specializedView.addSubview(bottomSpacer)
        
        specializedView.addSubview(gameHeader)
        
        specializedView.addSubview(gameFooter)
        
        topSpacer.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .top
                .equalToSuperview()
            make
                .bottom
                .equalTo(specializedView.safeAreaLayoutGuide.snp.top)
        }
        
        gameHeader.snp.makeConstraints { make in
            make
                .top
                .equalTo(specializedView.safeAreaLayoutGuide)
            make
                .leading
                .trailing
                .equalToSuperview()
        }
        
        scoreCardLayoutGuide.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .equalToSuperview()
            make
                .top
                .equalTo(gameHeader.snp.bottom)
            make
                .bottom
                .equalTo(gameFooter.snp.top)
        }
        
        gameHeader.setContentHuggingPriority(.required, for: .vertical)
        gameFooter.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .equalToSuperview()
            make
                .bottom
                .equalTo(addRoundButton.snp.top)
        }
        
        addRoundButton.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .equalToSuperview()
            make
                .bottom
                .equalTo(specializedView.safeAreaLayoutGuide.snp.bottom)
        }
        
        bottomSpacer.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .bottom
                .equalToSuperview()
            make
                .top
                .equalTo(specializedView.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc
    private func didTapAddRound() {
        listener?.wantNewRound()
    }
}
