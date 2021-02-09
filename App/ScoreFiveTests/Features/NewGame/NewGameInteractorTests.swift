//
//  NewGameInteractorTests.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 2/6/21.
//

@testable import ShortRibs
@testable import ScoreFive
import XCTest

final class NewGameInteractorTests: TestCase {
    
    let presenter = NewGamePresentableMock()
    let gameStorageManager = GameStorageManagingMock()
    let listener = NewGameListenerMock()
    
    var interactor: NewGameInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           gameStorageManager: gameStorageManager)
        interactor.listener = listener
    }
    
    func test_didTapClose_callsListener() {
        XCTAssertEqual(listener.newGameDidAbortCallCount, 0)
        interactor.didTapClose()
        XCTAssertEqual(listener.newGameDidAbortCallCount, 1)
    }
}
