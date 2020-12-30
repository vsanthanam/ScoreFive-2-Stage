//
//  NewRoundInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ShortRibs

/// @mockable
protocol NewRoundPresentable: NewRoundViewControllable {
    var listener: NewRoundPresentableListener? { get set }
}

/// @mockable
protocol NewRoundListener: AnyObject {}

final class NewRoundInteractor: PresentableInteractor<NewRoundPresentable>, NewRoundInteractable, NewRoundPresentableListener {
    
    // MARK: - Initializers
    
    init(presenter: NewRoundPresentable,
         replacingIndex: Int?) {
        self.replacingIndex = replacingIndex
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - API
    
    weak var listener: NewRoundListener?
    
    // MARK: - Private
    
    private let replacingIndex: Int?
}
