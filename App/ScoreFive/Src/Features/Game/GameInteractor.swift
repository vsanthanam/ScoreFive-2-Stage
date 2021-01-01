//
//  GameInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ScoreKeeping
import ShortRibs

/// @mockable
protocol GamePresentable: GameViewControllable {
    var listener: GamePresentableListener? { get set }
    func showNewRound(_ viewController: ViewControllable)
    func closeNewRound()
    func showScoreCard(_ viewController: ScoreCardViewControllable)
    func updateHeaderTitles(_ titles: [String])
}

/// @mockable
protocol GameListener: AnyObject {}

final class GameInteractor: PresentableInteractor<GamePresentable>, GameInteractable, GamePresentableListener {
    
    // MARK: - Initializers
    
    init(presenter: GamePresentable,
         gameStorageManager: GameStorageManaging,
         activeGameStream: ActiveGameStreaming,
         newRoundBuilder: NewRoundBuildable,
         scoreCardBuilder: ScoreCardBuildable) {
        self.gameStorageManager = gameStorageManager
        self.activeGameStream = activeGameStream
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
        startUpdatingHeaderTitles()
    }
    
    // MARK: - Private
    
    private let gameStorageManager: GameStorageManaging
    private let activeGameStream: ActiveGameStreaming
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
    
    private func startUpdatingHeaderTitles() {
        activeGameStream.activeGameIdentifier
            .filterNil()
            .map { [gameStorageManager] identifier in
                gameStorageManager.scoreCard(for: identifier)
            }
            .switchToLatest()
            .replaceError(with: nil)
            .removeDuplicates()
            .filterNil()
            .sink { card in
                let titles = card.orderedPlayers
                    .map(\.name)
                    .map { name in
                        String(name.prefix(1))
                    }
                self.presenter.updateHeaderTitles(titles)
            }
            .cancelOnDeactivate(interactor: self)
    }
}
