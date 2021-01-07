//
//  HomeInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ScoreKeeping
import ShortRibs

/// @mockable
protocol HomePresentable: HomeViewControllable {
    var listener: HomePresentableListener? { get set }
    func showNewGame(_ viewController: ViewControllable)
    func closeNewGame()
}

/// @mockable
protocol HomeListener: AnyObject {
    func homeWantToOpenGame(withIdentifier: UUID)
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {

    // MARK: - Initializers

    init(presenter: HomePresentable,
         gameStorageManager: GameStorageManaging,
         newGameBuilder: NewGameBuildable) {
        self.gameStorageManager = gameStorageManager
        self.newGameBuilder = newGameBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: HomeListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        openNewGameIfEmpty()
    }

    // MARK: - NewGameListener

    func newGameDidCreateNewGame(with identifier: UUID) {
        routeAwayFromNewGame()
        listener?.homeWantToOpenGame(withIdentifier: identifier)
    }

    func newGameDidAbort() {
        routeAwayFromNewGame()
    }

    // MARK: - Private

    private let gameStorageManager: GameStorageManaging
    private let newGameBuilder: NewGameBuildable

    private var currentNewGame: PresentableInteractable?

    private func openNewGameIfEmpty() {
        let records = (try? gameStorageManager.fetchGameRecords()) ?? []
        if records.isEmpty {
            routeToNewGame()
        }
    }

    private func routeToNewGame() {
        if let current = currentNewGame {
            detach(child: current)
        }
        let newGame = newGameBuilder.build(withListener: self)
        attach(child: newGame)
        presenter.showNewGame(newGame.viewControllable)
        currentNewGame = newGame
    }

    private func routeAwayFromNewGame() {
        if let current = currentNewGame {
            detach(child: current)
            presenter.closeNewGame()
        }
    }
}
