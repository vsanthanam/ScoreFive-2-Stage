//
//  ActiveGameManager.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ScoreKeeping
import Combine

/// @mockable
protocol ActiveGameStreaming: AnyObject {
    var activeGameIdentifier: AnyPublisher<UUID?, Never> { get }
    var currentActiveGameIdentifier: UUID? { get }
}

/// @mockable
protocol MutableActiveGameStreaming: ActiveGameStreaming {
    func activateGame(with uuid: UUID)
    func deactiveateCurrentGame()
}

final class ActiveGameStream: MutableActiveGameStreaming {
    
    // MARK: - ActiveGameStreaming
    
    @Published
    var currentActiveGameIdentifier: UUID? = nil
    
    var activeGameIdentifier: AnyPublisher<UUID?, Never> {
        $currentActiveGameIdentifier
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    // MARK: - MutableActiveGameStreaming
    
    func activateGame(with uuid: UUID) {
        currentActiveGameIdentifier = uuid
    }
    
    func deactiveateCurrentGame() {
        currentActiveGameIdentifier = nil
    }
}
