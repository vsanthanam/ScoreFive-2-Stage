//
//  GameLibraryViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 2/10/21.
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol GameLibraryViewControllable: ViewControllable {}

/// @mockable
protocol GameLibraryPresentableListener: AnyObject {}

final class GameLibraryViewController: ScopeViewController, GameLibraryPresentable, GameLibraryViewControllable {
    
    // MARK: - GameLibraryPresentable
    
    weak var listener: GameLibraryPresentableListener?
}
