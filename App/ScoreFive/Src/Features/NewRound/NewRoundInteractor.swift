//
//  NewRoundInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ScoreKeeping
import ShortRibs

/// @mockable
protocol NewRoundPresentable: NewRoundViewControllable {
    var listener: NewRoundPresentableListener? { get set }
    func setVisibleScore(_ score: Int?, with transition: NewRoundViewController.Transition)
    func setPlayerName(_ name: String?)
    func showResetError()
}

/// @mockable
protocol NewRoundListener: AnyObject {
    func newRoundDidCancel()
    func newRoundDidAddRound(_ round: Round)
    func newRoundDidReplaceRound(at index: Int, with round: Round)
}

final class NewRoundInteractor: PresentableInteractor<NewRoundPresentable>, NewRoundInteractable, NewRoundPresentableListener {

    // MARK: - Initializers

    init(presenter: NewRoundPresentable,
         activeGameStream: ActiveGameStreaming,
         gameStorageProvider: GameStorageProviding,
         replacingIndex: Int?,
         round: Round) {
        self.activeGameStream = activeGameStream
        self.gameStorageProvider = gameStorageProvider
        self.replacingIndex = replacingIndex
        self.round = round
        initialRound = round
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: NewRoundListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        guard let id = activeGameStream.currentActiveGameIdentifier,
            let card = try? gameStorageProvider.fetchScoreCard(for: id) else {
            listener?.newRoundDidCancel()
            return
        }

        players = card.orderedPlayers.filter { round.players.contains($0) }

        guard Set(players) == Set(round.players) else {
            listener?.newRoundDidCancel()
            return
        }

        if let score = round[players[currentPlayerIndex]], score != Round.noScore {
            presenter.setVisibleScore(score, with: .instant)
        }

        presenter.setPlayerName(players[currentPlayerIndex].name)
    }

    // MARK: - NewRoundPresentableListener

    func didTapClose() {
        listener?.newRoundDidCancel()
    }

    func didSaveScore(_ score: Int) {
        let player = players[currentPlayerIndex]
        round[player] = score

        if currentPlayerIndex < players.count - 1 {
            currentPlayerIndex += 1
            let nextPlayer = players[currentPlayerIndex]
            if let score = round[nextPlayer],
                score != Round.noScore {
                presenter.setVisibleScore(score, with: .forward)
                presenter.setPlayerName(players[currentPlayerIndex].name)
            } else {
                presenter.setVisibleScore(nil, with: .forward)
                presenter.setPlayerName(players[currentPlayerIndex].name)
            }
        } else {
            saveRound(adjustActiveEntry: true)
        }
    }

    func didInputScore(_ score: Int) {}

    private func saveRound(adjustActiveEntry: Bool) {
        guard round.isComplete else {
            return
        }

        let zeroes = players
            .compactMap { round.score(for: $0) }
            .filter { $0 == 0 }
        guard !zeroes.isEmpty else {
            if adjustActiveEntry {
                round[players[currentPlayerIndex]] = Round.noScore
                presenter.setVisibleScore(nil, with: .error)
            } else {
                // show error
                currentPlayerIndex = 0
                round = initialRound
                presenter.setVisibleScore(nil, with: .instant)
                presenter.showResetError()
            }
            return
        }
        guard zeroes.count < players.count else {
            if adjustActiveEntry {
                round[players[currentPlayerIndex]] = Round.noScore
                presenter.setVisibleScore(nil, with: .error)
            } else {
                // show error
            }
            return
        }

        if let index = replacingIndex {
            if let identifier = activeGameStream.currentActiveGameIdentifier,
                let card = try? gameStorageProvider.fetchScoreCard(for: identifier),
                card.canReplaceRound(at: index, with: round) {
                listener?.newRoundDidReplaceRound(at: index, with: round)
            } else {
                // handle error
                currentPlayerIndex = 0
                round = initialRound
                presenter.setVisibleScore(nil, with: .instant)
                presenter.showResetError()
            }
        } else {
            listener?.newRoundDidAddRound(round)
        }
    }

    // MARK: - Private

    private let activeGameStream: ActiveGameStreaming
    private let gameStorageProvider: GameStorageProviding

    private let replacingIndex: Int?

    private let initialRound: Round
    private var round: Round
    private var players = [Player]()

    private var currentPlayerIndex: Int = 0
}
