//
//  NewGameInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ShortRibs

/// @mockable
protocol NewGamePresentable: NewGameViewControllable {
    var listener: NewGamePresentableListener? { get set }
}

/// @mockable
protocol NewGameListener: AnyObject {}

final class NewGameInteractor: PresentableInteractor<NewGamePresentable>, NewGameInteractable, NewGamePresentableListener {
    
    // MARK: - Initializers
    
    override init(presenter: NewGamePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - API
    
    weak var listener: NewGameListener?
}
