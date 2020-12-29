//
//  GameStorageWorker.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Combine
import CoreData
import Foundation
import ScoreKeeping
import ShortRibs

/// @mockable
protocol GameStorageProviding: AnyObject {
    func fetchGame(for identifier: UUID) throws -> Game?
    func game(for identifier: UUID) -> AnyPublisher<Game?, Never>
    func fetchGames(inProgressOnly: Bool) throws -> [Game]
}

/// @mockable
protocol GameStorageManaging: GameStorageProviding {
    func saveGames() throws
    func newGame(from scoreCard: ScoreCard) throws -> Game
}

final class GameStorageManager: GameStorageManaging {
    
    // MARK: - Initializers
    
    init(persistentContainer: PersistentContaining) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - GameStorageProviding
    
    func fetchGame(for identifier: UUID) throws -> Game? {
        let filter = NSPredicate(format: "uniqueIdentifier == %@", identifier as CVarArg)
        let results = try fetch(withPredicate: filter)
        return results.first
    }
    
    func fetchGames(inProgressOnly: Bool) throws -> [Game] {
        var predicates = [NSPredicate]()
        if inProgressOnly {
            let filter = NSPredicate(format: "inProgress == YES")
            predicates.append(filter)
        }
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return try fetch(withPredicate: predicate)
    }
    
    func game(for identifier: UUID) -> AnyPublisher<Game?, Never> {
        saveSubject
            .tryMap { [weak self] _ -> Game? in
                if let self = self {
                    return try self.fetchGame(for: identifier)
                }
                return nil
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    // MARK: - GameStorageManaging
    
    func saveGames() throws {
        try persistentContainer.viewContext.save()
        saveSubject.send(())
    }
    
    func newGame(from scoreCard: ScoreCard) throws -> Game {
        let game = GameMO()
        try game.updateScoreCard(scoreCard: scoreCard)
        game.uniqueIdentifier = .init()
        try persistentContainer.viewContext.save()
        return game
    }

    // MARK: - Private
    
    private let persistentContainer: PersistentContaining
    private let saveSubject = PassthroughSubject<(), Never>()
    
    private func fetch(withPredicate predicate: NSPredicate? = nil) throws -> [Game] {
        let request: NSFetchRequest<GameMO> = GameMO.fetchRequest()
        request.predicate = predicate
        let results = try persistentContainer.viewContext.fetch(request)
        return results
    }
}

extension GameStorageProviding {
    func fetchGames() throws -> [Game] {
        try fetchGames(inProgressOnly: false)
    }
}
