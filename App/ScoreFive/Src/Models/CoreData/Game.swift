//
//  Game+CoreDataClass.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//
//

import Foundation
import CoreData
import ScoreKeeping

protocol Game: AnyObject {
    var inProgress: Bool { get }
    var gameIdentifier: UUID { get }
    var scoreCard: ScoreCard? { get set }
    func getScoreCard() throws -> ScoreCard
    func updateScoreCard(scoreCard: ScoreCard) throws
}

@objc(Game)
public class GameMO: NSManagedObject, Game {

    // MARK: - API
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<GameMO> {
        .init(entityName: "GameMO")
    }

    @NSManaged
    public var scoreCardData: Data?
    
    @NSManaged
    public var uniqueIdentifier: UUID?
    
    @NSManaged
    public var inProgress: Bool
    
    // MARK: - MSManagedObjejct
    
    public override func willSave() {
        super.willSave()
        inProgress = (try? getScoreCard())?.canAddRounds ?? false
    }
    
    // MARK: - Game
    
    var gameIdentifier: UUID { uniqueIdentifier! }
    
    var scoreCard: ScoreCard? {
        get {
            do {
                return try getScoreCard()
            } catch {
                assertionFailure("Couldn't decode score card data")
                return nil
            }
        }
        set {
            if let card = newValue {
                try? updateScoreCard(scoreCard: card)
            } else {
                assertionFailure("Couldn't encode score card")
            }
        }
    }
    
    func getScoreCard() throws -> ScoreCard {
        let decoder = JSONDecoder()
        return try decoder.decode(ScoreCard.self, from: scoreCardData!)
    }
    
    func updateScoreCard(scoreCard: ScoreCard) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(scoreCard)
        scoreCardData = data
        inProgress = scoreCard.canAddRounds
    }
}
