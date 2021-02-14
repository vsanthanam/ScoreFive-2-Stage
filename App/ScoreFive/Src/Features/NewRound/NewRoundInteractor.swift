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
    func advanceToNextPlayer()
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
    }

    // MARK: - NewRoundPresentableListener

    func didTapClose() {
        listener?.newRoundDidCancel()
    }
    
    func didSaveScore(_ score: Int) {
        let player = players[currentPlayerIndex]
        round[player] = score
        print(round)
        
        if currentPlayerIndex < players.count - 1 {
            currentPlayerIndex += 1
            presenter.advanceToNextPlayer()
        } else {
            if let index = replacingIndex {
                listener?.newRoundDidReplaceRound(at: index, with: round)
            } else {
                listener?.newRoundDidAddRound(round)
            }
        }
    }

    // MARK: - Private

    private let activeGameStream: ActiveGameStreaming
    private let gameStorageProvider: GameStorageProviding

    private let replacingIndex: Int?

    private var round: Round
    private var players = [Player]()
    
    private var currentPlayerIndex: Int = 0
}
