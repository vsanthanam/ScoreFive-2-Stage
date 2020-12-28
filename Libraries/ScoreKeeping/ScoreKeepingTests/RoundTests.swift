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
        XCTAssertEqual(round.players.count, 0)
    }
    
}
