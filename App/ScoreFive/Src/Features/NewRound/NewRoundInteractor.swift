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

    // MARK: - NewRoundPresentableListener

    func didTapClose() {
        listener?.newRoundDidCancel()
    }

    // MARK: - Private

    private let activeGameStream: ActiveGameStreaming
    private let gameStorageProvider: GameStorageProviding

    private let replacingIndex: Int?

    private var round: Round
}
