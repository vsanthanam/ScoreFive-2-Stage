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
    func showResumeButton()
    func hideResumeButton()
    func showNewGame(_ viewController: ViewControllable)
    func closeNewGame()
    func showMoreOptions(_ viewController: ViewControllable)
    func closeMoreOptions()
    func showGameLibrary(_ viewController: ViewControllable)
    func closeGameLibrary()
}

/// @mockable
protocol HomeListener: AnyObject {
    func homeWantToOpenGame(withIdentifier: UUID)
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {

    // MARK: - Initializers

    init(presenter: HomePresentable,
         gameStorageManager: GameStorageManaging,
         newGameBuilder: NewGameBuildable,
         moreOptionsBuilder: MoreOptionsBuildable,
         gameLibraryBuilder: GameLibraryBuildable) {
        self.gameStorageManager = gameStorageManager
        self.newGameBuilder = newGameBuilder
        self.moreOptionsBuilder = moreOptionsBuilder
        self.gameLibraryBuilder = gameLibraryBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: HomeListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        openNewGameIfEmpty()
        checkForResume()
    }

    // MARK: - NewGameListener

    func newGameDidCreateNewGame(with identifier: UUID) {
        routeAwayFromNewGame()
        listener?.homeWantToOpenGame(withIdentifier: identifier)
    }

    func newGameDidAbort() {
        routeAwayFromNewGame()
    }
    
    // MARK: - MoreOptionsListener
    
    func moreOptionsDidResign() {
        routeAwayFromMoreOptions()
    }
    
    // MARK: - GameLibraryListener
    
    func gameLibraryDidResign() {
        routeAwayFromGameLibrary()
    }

    // MARK: - HomePresentableListener

    func didTapNewGame() {
        routeToNewGame()
    }

    func didTapResumeLastGame() {
        do {
            let games = try gameStorageManager.fetchInProgressGameRecords()
            if let identifier = games.first?.uniqueIdentifier {
                listener?.homeWantToOpenGame(withIdentifier: identifier)
            }
        } catch {
            return
        }
    }

    func didTapLoadGame() {
        routeToGameLibrary()
    }

    func didTapMore() {
        routeToMoreOptions()
    }

    // MARK: - Private

    private let gameStorageManager: GameStorageManaging
    private let newGameBuilder: NewGameBuildable
    private let moreOptionsBuilder: MoreOptionsBuildable
    private let gameLibraryBuilder: GameLibraryBuildable
    
    private var currentNewGame: PresentableInteractable?
    private var currentMoreOptions: PresentableInteractable?
    private var currentGameLibrary: PresentableInteractable?

    private func openNewGameIfEmpty() {
        let records = (try? gameStorageManager.fetchGameRecords()) ?? []
        if records.isEmpty {
            routeToNewGame()
        }
    }

    private func checkForResume() {
        do {
            let inProgress = try gameStorageManager.fetchGameRecords()
            if !inProgress.isEmpty {
                presenter.showResumeButton()
            } else {
                presenter.hideResumeButton()
            }
        } catch {}
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
        currentNewGame = nil
    }

    private func routeToMoreOptions() {
        if let current = currentMoreOptions {
            detach(child: current)
        }
        let moreOptions = moreOptionsBuilder.build(withListener: self)
        attach(child: moreOptions)
        presenter.showMoreOptions(moreOptions.viewControllable)
        currentMoreOptions = moreOptions
    }
    
    private func routeAwayFromMoreOptions() {
        if let current = currentMoreOptions {
            detach(child: current)
            presenter.closeMoreOptions()
        }
        currentMoreOptions = nil
    }
    
    private func routeToGameLibrary() {
        if let current = currentNewGame {
            detach(child: current)
        }
        let gameLibrary = gameLibraryBuilder.build(withListener: self)
        attach(child: gameLibrary)
        presenter.showGameLibrary(gameLibrary.viewControllable)
        currentGameLibrary = gameLibrary
    }
    
    private func routeAwayFromGameLibrary() {
        if let current = currentGameLibrary {
            detach(child: current)
            presenter.closeGameLibrary()
        }
        currentGameLibrary = nil
    }
}
