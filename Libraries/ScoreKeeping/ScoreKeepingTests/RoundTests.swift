//
//  RoundTests.swift
//  ScoreKeepingTests
//
//  Created by Varun Santhanam on 12/28/20.
//

@testable import ScoreKeeping
import XCTest

final class RoundTests: XCTestCase {

    func test_init_emptyRound() {
        let round = Round()
        XCTAssertEqual(round.players.count, 0, "Empty round should contain zero players!")
    }

    func test_assignScore_retreive() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        let player2 = Player.test
        round.set(score: 50, for: player1)
        XCTAssertEqual(round.score(for: player1), 50, "player1 should have assigned score of 50")
        round.set(score: 0, for: player2)
        XCTAssertEqual(round.score(for: player2), 0, "player2 should have assigned score of 0")
    }

    func test_assignedScore_retrieve_subscript() {
        var round = Round()
        let player1 = Player.test
        let player2 = Player.test
        round[player1] = 50
        XCTAssertEqual(round[player1], 50, "player1 should have assigned score of 50")
        round[player2] = 0
        XCTAssertEqual(round[player2], 0, "player2 should have assigned score of 0")
    }

    func test_assignScore_addsPlayers() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        let player2 = Player.test
        round.set(score: 50, for: player1)
        XCTAssertTrue(round.players.contains(player1), "Round should have a score for player1")
        round.set(score: 0, for: player2)
        XCTAssertTrue(round.players.contains(player2), "Round should have a score for player2")
        XCTAssertEqual(round.players.count, 2, "Round should have only 2 players")
    }

    func test_assignScore_addsPlayers_subscript() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        let player2 = Player.test
        round[player1] = 50
        XCTAssertTrue(round.players.contains(player1), "Round should have a score for player1")
        round[player2] = 0
        XCTAssertTrue(round.players.contains(player2), "Round should have a score for player2")
        XCTAssertEqual(round.players.count, 2, "Round should have only 2 players")
    }

    func test_assignSscore_missingPlayer_returnsNil() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let testPlayer = Player.test
        round.set(score: 50, for: testPlayer)
        let missingPlayer = Player.test
        XCTAssertNil(round.score(for: missingPlayer), "Missing player's score should be nil")
    }

    func test_assignSscore_missingPlayer_returnsNil_subscript() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let testPlayer = Player.test
        round[testPlayer] = 50
        let missingPlayer = Player.test
        XCTAssertNil(round[missingPlayer], "Missing player's score should be nil")
    }

    func test_assignSscore_missingPlayer_notContained() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let testPlayer = Player.test
        round.set(score: 50, for: testPlayer)
        let missingPlayer = Player.test
        XCTAssertFalse(round.players.contains(missingPlayer), "Missing player shouldn't be included")
        XCTAssertEqual(round.players.count, 1, "Round should have only 1 player")
    }

    func test_removeScore_returnsNil() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        round.set(score: 50, for: player1)
        XCTAssertEqual(round.score(for: player1), 50, "player1 should have assigned score of 50")
        round.removeScore(for: player1)
        XCTAssertEqual(round.score(for: player1), Round.noScore, "player1 should have an empty score")
    }

    func test_removeScore_returnsNil_subscript() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        round.set(score: 50, for: player1)
        XCTAssertEqual(round[player1], 50, "player1 should have assigned score of 50")
        round[player1] = nil
        XCTAssertNil(round[player1], "player1 should have a nil score")
    }

    func test_removeScore_doesntRemovePlayer() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        round.set(score: 50, for: player1)
        XCTAssertTrue(round.players.contains(player1), "Round should have a score for player1")
        round.removeScore(for: player1)
        XCTAssertTrue(round.players.contains(player1), "player1 should be included")
        XCTAssertEqual(round.players.count, 1, "Round should have only 1 player")
    }

    func test_removeScore_removesPlayer_subscript() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        round[player1] = 10
        XCTAssertTrue(round.players.contains(player1), "Round should have a score for player1")
        round[player1] = nil
        XCTAssertFalse(round.players.contains(player1), "player1 shouldn't be included")
        XCTAssertEqual(round.players.count, 0, "Round shouldn't have any players")
    }

    func test_assignedScore_replacesPreviousScore() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        round.set(score: 23, for: player1)
        XCTAssertEqual(round.score(for: player1), 23, "player1 should have assigned score of 23")
        round.set(score: 50, for: player1)
        XCTAssertEqual(round.score(for: player1), 50, "player2 should have assigned score of 50")
    }

    func test_assignedScore_doesntAddPlayer() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        round.set(score: 23, for: player1)
        round.set(score: 50, for: player1)
        XCTAssertEqual(round.players.count, 1, "Round should only have 1 player")
        XCTAssertTrue(round.players.contains(player1), "Round should have a score for player1")
    }

    func test_assignedScore_replacesPreviousScore_subscript() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        round[player1] = 23
        XCTAssertEqual(round[player1], 23, "player1 should have assigned score of 23")
        round[player1] = 50
        XCTAssertEqual(round[player1], 50, "player2 should have assigned score of 50")
    }

    func test_assignedScore_doesntAddPlayer_subscript() {
        var round = Round()
        XCTAssertEqual(round.players.count, 0)
        let player1 = Player.test
        round[player1] = 23
        round[player1] = 50
        XCTAssertEqual(round.players.count, 1, "Round should only have 1 player")
        XCTAssertTrue(round.players.contains(player1), "Round should have a score for player1")
    }

    func test_equality() {
        let player1 = Player.test
        let player2 = Player.test
        var round1 = Round()
        var round2 = Round()
        var round3 = Round()

        round1[player1] = 0
        round1[player2] = 12
        round2[player1] = 34
        round2[player2] = 0
        round3[player1] = 0
        round3[player2] = 12
        XCTAssertEqual(round1, round1)
        XCTAssertNotEqual(round1, round2)
        XCTAssertEqual(round1, round3)
    }
}

private extension Player {
    static var test: Player {
        .init(name: "Test Player", uuid: .init())
    }
}
