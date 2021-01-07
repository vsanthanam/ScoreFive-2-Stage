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
}

final class NewRoundInteractor: PresentableInteractor<NewRoundPresentable>, NewRoundInteractable, NewRoundPresentableListener {

    // MARK: - Initializers

    init(presenter: NewRoundPresentable,
         replacingIndex: Int?,
         previousValue: Round?) {
        self.replacingIndex = replacingIndex
        round = previousValue ?? Round()
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

    private let replacingIndex: Int?

    private var round: Round
}
