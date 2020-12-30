//
//  GameInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ShortRibs

/// @mockable
protocol GamePresentable: GameViewControllable {
    var listener: GamePresentableListener? { get set }
    func showNewRound(_ viewController: ViewControllable)
    func closeNewRound()
    func showScoreCard(_ viewController: ScoreCardViewControllable)
}

/// @mockable
protocol GameListener: AnyObject {}

final class GameInteractor: PresentableInteractor<GamePresentable>, GameInteractable, GamePresentableListener {
    
    // MARK: - Initializers
    
    init(presenter: GamePresentable,
         newRoundBuilder: NewRoundBuildable,
         scoreCardBuilder: ScoreCardBuildable) {
        self.newRoundBuilder = newRoundBuilder
        self.scoreCardBuilder = scoreCardBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - API
    
    weak var listener: GameListener?
    
    // MARK: - Interactor
    
    override func didBecomeActive() {
        super.didBecomeActive()
        attachScoreCard()
    }
    
    // MARK: - Private
    
    private let newRoundBuilder: NewRoundBuildable
    private let scoreCardBuilder: ScoreCardBuildable
    
    private var currentNewRound: PresentableInteractable?
    private var currentScoreCard: ScoreCardInteractable?
    
    private func routeToNewRound(replacingIndex: Int? = nil) {
        if let current = currentNewRound {
            detach(child: current)
        }
        let newRound = newRoundBuilder.build(withListener: self, replacingIndex: replacingIndex)
        attach(child: newRound)
        presenter.showNewRound(newRound.viewControllable)
        currentNewRound = newRound
    }
    
    private func routeAwayFromNewRound() {
        if let current = currentNewRound {
            detach(child: current)
            presenter.closeNewRound()
            currentNewRound = nil
        }
    }
    
    private func attachScoreCard() {
        if currentScoreCard == nil {
            let scoreCard = scoreCardBuilder.build(withListener: self)
            attach(child: scoreCard)
            presenter.showScoreCard(scoreCard.viewController)
            currentScoreCard = scoreCard
        }
    }
}
