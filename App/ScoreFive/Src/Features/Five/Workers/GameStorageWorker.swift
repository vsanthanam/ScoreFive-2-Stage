//
//  GameStorageWorker.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
import ShortRibs

/// @mockable
protocol GameStorageProviding: AnyObject {}

/// @mockable
protocol GameStorageManaging: GameStorageProviding {}

/// @mockable
protocol GameStorageWorking: GameStorageManaging, Working {}

final class GameStorageWorker: Worker, GameStorageWorking {
    
    // MARK: - Initializers
    
    init(persistentContainer: PersistentContaining) {
        self.persistentContainer = persistentContainer
        super.init()
    }
    
    // MARK: - Private
    
    private let persistentContainer: PersistentContaining
    
}
