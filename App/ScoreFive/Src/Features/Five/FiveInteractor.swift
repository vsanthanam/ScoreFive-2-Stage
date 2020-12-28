//
//  FiveInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
import ShortRibs

/// @mockable
protocol FivePresentable: FiveViewControllable {
    var listener: FivePresentableListener? { get set }
}

/// @mockable
protocol FiveListener: AnyObject {}

final class FiveInteractor: PresentableInteractor<FivePresentable>, FiveInteractable, FivePresentableListener {
    
    // MARK: - Initializers
    
    init(presenter: FivePresentable,
         gameStorageWorker: GameStorageWorking) {
        self.gameStorageWorker = gameStorageWorker
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - API
    
    weak var listener: FiveListener?
    
    // MARK: - Interactor
    
    override func didBecomeActive() {
        super.didBecomeActive()
        gameStorageWorker.start(on: self)
    }
    
    // MARK: - FiveInteractable
    
    var viewController: ViewControllable {
        presenter
    }
    
    // MARK: - Private
    
    private let gameStorageWorker: GameStorageWorking
    
}
