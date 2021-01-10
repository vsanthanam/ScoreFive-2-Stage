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
         previousValue: Round?) {
        self.activeGameStream = activeGameStream
        self.gameStorageProvider = gameStorageProvider
        self.replacingIndex = replacingIndex
        round = previousValue ?? Round()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        fetchLatestScoreCard()
    }

    // MARK: - API

    weak var listener: NewRoundListener?

    // MARK: - NewRoundPresentableListener

    func didTapClose() {
        listener?.newRoundDidCancel()
    }

    // MARK: - Private

    private let activeGameStream: ActiveGameStreaming
    private let gameStorageProvider: GameStorageProviding

    private let replacingIndex: Int?

    private var round: Round
    private var scoreCard: ScoreCard?

    private func fetchLatestScoreCard() {
        guard let identifier = activeGameStream.currentActiveGameIdentifier else {
            listener?.newRoundDidCancel()
            return
        }
        do {
            scoreCard = try gameStorageProvider.fetchScoreCard(for: identifier)
        } catch {
            listener?.newRoundDidCancel()
        }
    }
}
