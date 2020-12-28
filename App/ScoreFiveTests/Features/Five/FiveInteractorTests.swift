//
//  FiveInteractorTests.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
@testable import ScoreFive
@testable import ShortRibs
import XCTest

final class FiveInteractorTests: XCTestCase {
    
    let presenter = FivePresentableMock()
    let gameStorageWorker = GameStorageWorkingMock()
    
    var interactor: FiveInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter, gameStorageWorker: gameStorageWorker)
    }
    
    func test_init_setsPresenterListener() {
        XCTAssertTrue(presenter.listener === self.interactor)
    }
    
    func test_activate_startsGameStorageWorker() {
        XCTAssertEqual(gameStorageWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(gameStorageWorker.startCallCount, 1)
    }
}


