//
//  FiveInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
import ShortRibs
import ScoreKeeping

/// @mockable
protocol FivePresentable: FiveViewControllable {
    var listener: FivePresentableListener? { get set }
}

/// @mockable
protocol FiveListener: AnyObject {}

final class FiveInteractor: PresentableInteractor<FivePresentable>, FiveInteractable, FivePresentableListener {
    
    // MARK: - Initializers
    
    override init(presenter: FivePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - API
    
    weak var listener: FiveListener?
    
    // MARK: - FiveInteractable
    
    var viewController: ViewControllable {
        presenter
    }
    
}
