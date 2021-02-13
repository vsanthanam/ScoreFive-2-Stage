//
//  ScoreCard.swift
//  ScoreKeeping
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation

/// A `ScoreCard` is a struct used to record a game of five.
/// The card is initialized with a score limit and a list of players.
/// Rounds are added to the card until players are eliminated by crossing the score limit
/// The game ends when there is only 1 player left.
public struct ScoreCard: Codable, Equatable, Hashable {

    // MARK: - Initializers

    /// Create a `ScoreCard`
    /// - Parameters:
    ///   - scoreLimit: The score limit used to eliminate players. Defaults to 250.
    ///   - orderedPlayers: The players in this game, ordered by who plays first.
    /// - Note: This initializer produces a runtime failure if the provided score limit is less than 50, if fewer than 2 players are provided, or if more than 8 players are provided.b
    public init(scoreLimit: Int = 250,
                orderedPlayers: [Player]) {
        precondition(orderedPlayers.count >= 2, "There must be at least 2 players in a game")
        precondition(orderedPlayers.count <= 8, "There can only be 8 players in a game")
        precondition(scoreLimit >= 50, "Score limit must be at least 50")
        self.scoreLimit = scoreLimit
        self.orderedPlayers = orderedPlayers
    }

    // MARK: - API

    /// The score limit used to eliminate players
    public private(set) var scoreLimit: Int

    /// All the players in the game, in order of who goes firest
    public let orderedPlayers: [Player]

    /// All the players remaining in the game, in order of who goes first
    public var activePlayers: [Player] {
        orderedPlayers
            .filter { player in
                totalScore(for: player) < scoreLimit
            }
    }

    /// All the players in the game, from winning to losing
    public var rankedPlayers: [Player] {
        orderedPlayers
            .sorted { lhs, rhs -> Bool in
                totalScore(for: lhs) < totalScore(for: rhs)
            }
    }

    /// All the players remaining the game, from winning to losing
    public var activePlayersRanked: [Player] {
        rankedPlayers
            .filter { player in
                totalScore(for: player) < scoreLimit
            }
    }

    /// Whether or not the game is in progress and can accept new rounds
    public var canAddRounds: Bool {
        activePlayers.count > 1
    }

    /// The number of rounds in this score card
    public var numberOfRounds: Int {
        rounds.count
    }

    public var percentComplete: Double {
        let reducedTotal = orderedPlayers
            .map(totalScore(for:))
            .map { score in
                score >= scoreLimit ? scoreLimit : score
            }
            .sorted()
            .dropFirst()
            .reduce(0) { total, next in
                total + next
            }
        return Double(reducedTotal) / Double(orderedPlayers.count - 1)
    }

    /// The rounds in this game
    public private(set) var rounds = [Round]()

    /// The total score for a player
    /// - Parameter player: The player
    /// - Returns: The total score for the player
    /// - Note: This method produces a run-time failure if the player is not in this game
    public func totalScore(for player: Player) -> Int {
        totalScore(forPlayer: player, atIndex: rounds.count - 1)
    }

    /// Get the round at the specified index
    /// - Parameter index: The specified index
    /// - Returns: The round at that index
    /// - Note: This method produces a run-time failure no such index exists
    public func round(at index: Int) -> Round {
        guard index < rounds.count else {
            fatalError("This game does not contain a round at this index")
        }
        return rounds[index]
    }

    /// Whether or not a round can be replaced with a new round
    /// - Parameters:
    ///   - index: The index of the round you want to replace
    ///   - newRound: The new round
    /// - Returns: Whether or not the update is permissable
    /// - Note: You cannot update a round with a new round that would change which players have been eliminated, unless that round is the most recent round.
    public func canReplaceRound(at index: Int, with newRound: Round?) -> Bool {
        guard index < rounds.count else {
            return false
        }
        if index == (rounds.count - 1) {
            return true
        }
        var copy = self
        let activePlayers = copy.activePlayers
        if let newRound = newRound {
            copy.rounds[index] = newRound
        } else {
            copy.rounds.remove(at: index)
        }
        return activePlayers == copy.activePlayers
    }

    /// Whether or not a round can be safely removed.
    /// - Parameter index: The index of the round you want to remove
    /// - Returns: Whether or not the removal is permissable
    /// - Note: You cannot remove a round that would change which players have been eliminated, unless that round is the most recent round.
    public func canRemoveRound(at index: Int) -> Bool {
        canReplaceRound(at: index, with: nil)
    }

    /// Remove the round at the specified index
    /// - Parameter index: The index used to remove the round
    /// - Note: This method prodiuces a run-time failure if no such index exists, or if the desired removal is not permissable.
    ///         You can validate a removal before attempting to make one using `canRemoveRound(at:)`
    public mutating func removeRound(at index: Int) {
        guard index < rounds.count else {
            fatalError("This game does not contain a round at this index")
        }
        if index == (rounds.count - 1) {
            rounds.remove(at: index)
        } else {
            let previouslyActivePlayers = activePlayers
            rounds.remove(at: index)
            precondition(previouslyActivePlayers == activePlayers, "Round removal must not change active players")
        }
    }

    /// Createa a new card, without a specific round
    /// - Parameter index: The index of the round that should be absent in the new card
    /// - Returns: The new card
    public func cardByRemovingRound(at index: Int) -> ScoreCard {
        var copy = self
        copy.removeRound(at: index)
        return copy
    }

    /// Replace the round at the given index
    /// - Parameters:
    ///   - index: The index to replace
    ///   - newRound: The new round
    /// - Note: This method produes a run-time failure if the index doesn't exist in the score card, or if the desired change is not permissable.
    ///         You can validate a change before attempting ot make one using `canReplaceRound(at:with:)`
    public mutating func replaceRound(at index: Int, with newRound: Round) {
        guard canReplaceRound(at: index, with: newRound) else {
            fatalError("Cannot replace round with new round that would change which players have or haven't been eliminated")
        }
        rounds[index] = newRound
    }

    /// Creates a new card, but with a round replaced with a new one
    /// - Parameters:
    ///   - index: The index of the round you want replaced
    ///   - newRound: The new round
    /// - Returns: The new card
    public func cardByReplacingRound(at index: Int, with newRound: Round) -> ScoreCard {
        var copy = self
        copy.replaceRound(at: index, with: newRound)
        return copy
    }

    /// Update the score limit
    /// - Parameter scoreLimit: The new score limit
    /// - Note: This method produces a run-time failure if this new score limit eliminates any existing players. The new score limit can revive previously eliminated players, however.
    public mutating func updateScoreLimit(_ scoreLimit: Int) {
        fatalError("This method hasn't been implemented yet.")
    }

    /// Create a card with an updated score limit
    /// - Parameter scoreLimit: The new score limit
    /// - Returns: The new card
    public func cardWithUpdatedScoreLimit(_ scoreLimit: Int) -> ScoreCard {
        var copy = self
        copy.updateScoreLimit(scoreLimit)
        return copy
    }

    /// Add a new round
    /// - Parameter round: The new round to add
    /// - Note: This method produces a run-time failure if this round doesn't contain the right players or doesn't contain at least 1 winner and 1 loser.
    public mutating func addRound(_ round: Round) {
        precondition(round.isComplete, "This round is missing scores and cannot be added until it has a score for every player")
        precondition(canAddRounds, "This game cannot accept rounds unless its score limit is increased or existing rounds are removed")
        precondition(Set(round.players) == Set(activePlayers), "Round players do not match currently active players")
        let zeros = round.containedScores.filter { score in score == 0 }
        precondition(zeros.count >= 1, "Round must contain at least 1 winner before being added")
        precondition(zeros.count < round.players.count, "Round must contain 1 loser before being added")
        rounds.append(round)
        precondition(activePlayers.count >= 1, "Round must leave at least one player standing after being added")
    }

    /// Create a new round with the correct players for the next round
    /// - Returns: The new round, with no scores
    public func newRound() -> Round {
        guard activePlayers.count >= 2 else {
            fatalError()
        }
        return .init(players: activePlayers)
    }

    // MARK: - Subscript

    public subscript(player: Player) -> Int {
        totalScore(for: player)
    }

    public subscript(index: Int) -> Round {
        round(at: index)
    }

    private func partialGame(atIndex index: Int) -> ScoreCard {
        precondition(index < rounds.count, "This round hasn't happend yet")
        var partial = ScoreCard(scoreLimit: scoreLimit, orderedPlayers: orderedPlayers)
        partial.rounds = .init(rounds.prefix(index + 1))
        return partial
    }

    private func totalScore(forPlayer player: Player, atIndex index: Int) -> Int {
        precondition(index < rounds.count, "This round hasn't happened yet")
        precondition(orderedPlayers.contains(player), "This score card does not contain this player")
        return rounds
            .prefix(index + 1)
            .filter { round in
                round.containsScore(for: player)
            }
            .reduce(0) { total, round in
                total + (round.score(for: player) ?? 0)
            }
    }
}

private extension Round {

    func containsScore(for player: Player) -> Bool {
        score(for: player) != Round.noScore
    }

    var containedScores: [Int] {
        players
            .map(score(for:))
            .compactMap { $0 }
            .filter { $0 != Round.noScore }
    }
}
