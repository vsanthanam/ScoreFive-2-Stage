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
    func updateTotalScores(_ scores: [String])
}

/// @mockable
protocol GameListener: AnyObject {
    func gameWantToResign()
}

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
        startUpdatingTotalScores()
    }

    // MARK: - GamePresentableListener

    func wantNewRound() {
        routeToNewRound()
    }

    func didClose() {
        listener?.gameWantToResign()
    }

    // MARK: - ScoreCardListener

    func scoreCardDidDeleteRound(at index: Int) {
        if let identifier = activeGameStream.currentActiveGameIdentifier,
            var card = try? gameStorageManager.fetchScoreCard(for: identifier) {
            card.removeRound(at: index)
            try? gameStorageManager.save(scoreCard: card, with: identifier)
        }
    }

    // MARK: - NewGameListener

    func newRoundDidCancel() {
        routeAwayFromNewRound()
    }

    func newRoundDidAddRound(_ round: Round) {}

    func newRoundDidReplaceRound(at index: Int, with round: Round) {}

    // MARK: - Private

    private let gameStorageManager: GameStorageManaging
    private let activeGameStream: ActiveGameStreaming
    private let newRoundBuilder: NewRoundBuildable
    private let scoreCardBuilder: ScoreCardBuildable

    private var currentNewRound: PresentableInteractable?
    private var currentScoreCard: ScoreCardInteractable?

    private func routeToNewRound() {
        if let current = currentNewRound {
            detach(child: current)
        }
        let newRound = newRoundBuilder.build(withListener: self)
        attach(child: newRound)
        presenter.showNewRound(newRound.viewControllable)
        currentNewRound = newRound
    }

    private func routeToNewRound(replacing index: Int, previousValue: Round) {
        if let current = currentNewRound {
            detach(child: current)
        }
        let newRound = newRoundBuilder.build(withListener: self,
                                             replacingIndex: index,
                                             previousValue: previousValue)
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

    func startUpdatingTotalScores() {
        activeGameStream.activeGameIdentifier
            .filterNil()
            .map { [gameStorageManager] identifier in
                gameStorageManager.scoreCard(for: identifier)
            }
            .switchToLatest()
            .filterNil()
            .sink { card in
                let scores = card.orderedPlayers
                    .map { player in
                        String(card.totalScore(for: player))
                    }
                self.presenter.updateTotalScores(scores)
            }
            .cancelOnDeactivate(interactor: self)
    }
}
