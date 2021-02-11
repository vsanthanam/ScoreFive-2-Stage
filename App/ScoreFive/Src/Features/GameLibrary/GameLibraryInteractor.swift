//
//  GameLibraryInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 2/10/21.
//

import Foundation
import ShortRibs

/// @mockable
protocol GameLibraryPresentable: GameLibraryViewControllable {
    var listener: GameLibraryPresentableListener? { get set }
}

/// @mockable
protocol GameLibraryListener: AnyObject {}

final class GameLibraryInteractor: PresentableInteractor<GameLibraryPresentable>, GameLibraryInteractable, GameLibraryPresentableListener {
    
    // MARK: - API
    
    weak var listener: GameLibraryListener?    
}
