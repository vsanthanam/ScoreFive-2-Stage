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
    func fetchScoreCard(for identifier: UUID) throws -> ScoreCard?
    func scoreCard(for identifier: UUID) -> AnyPublisher<ScoreCard?, Never>
    func fetchGames() throws -> [GameRecord]
    func fetchInProgressGames() throws -> [GameRecord]
}

/// @mockable
protocol GameStorageManaging: GameStorageProviding {
    func newGame(from scoreCard: ScoreCard) throws -> GameRecord
    func save(scoreCard: ScoreCard, with identifier: UUID) throws
    func saveAllGames() throws
}

final class GameStorageManager: GameStorageManaging {
    
    // MARK: - Initializers
    
    init(persistentContainer: PersistentContaining) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - GameStorageProviding
    
    func fetchScoreCard(for identifier: UUID) throws -> ScoreCard? {
        try fetchGame(for: identifier)?.getScoreCard()
    }
    
    func fetchGames() throws -> [GameRecord] {
        let request = buildFetchRequest()
        return try persistentContainer.viewContext.fetch(request)
    }
    
    func fetchInProgressGames() throws -> [GameRecord] {
        let predicate = NSPredicate(format: "inProgress == YES")
        let request = buildFetchRequest(withPredicate: predicate)
        return try persistentContainer.viewContext.fetch(request)
    }
    
    func scoreCard(for identifier: UUID) -> AnyPublisher<ScoreCard?, Never> {
        saveSubject
            .tryMap { [weak self] _ -> GameRecord? in
                if let self = self {
                    return try self.fetchGame(for: identifier)
                }
                return nil
            }
            .tryMap { game in
                try game?.getScoreCard()
            }
            .replaceError(with: nil)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    // MARK: - GameStorageManaging
    
    func newGame(from scoreCard: ScoreCard) throws -> GameRecord {
        let game = GameRecordMO(context: persistentContainer.viewContext)
        try game.updateScoreCard(scoreCard: scoreCard)
        game.rawIdentifier = .init()
        try persistentContainer.viewContext.save()
        return game
    }
    
    func save(scoreCard: ScoreCard, with identifier: UUID) throws {
        let game = try fetchGame(for: identifier)
        try game?.updateScoreCard(scoreCard: scoreCard)
        try saveAllGames()
    }
    
    func saveAllGames() throws {
        try persistentContainer.viewContext.save()
        saveSubject.send(())
    }
    
    // MARK: - Private
    
    private let persistentContainer: PersistentContaining
    private let saveSubject = PassthroughSubject<(), Never>()
    
    private func fetchGame(for identifier: UUID) throws -> GameRecord? {
        let filter = NSPredicate(format: "rawIdentifier == %@", identifier as CVarArg)
        let request = buildFetchRequest(withPredicate: filter)
        let results = try persistentContainer.viewContext.fetch(request)
        if results.count > 1 {
            throw GameStorageError.unknown
        }
        return results.first
    }
    
    private func buildFetchRequest(withPredicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) -> NSFetchRequest<GameRecordMO> {
        let request: NSFetchRequest<GameRecordMO> = GameRecordMO.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return request
    }
    
    enum GameStorageError: Error {
        case unknown
    }
}
