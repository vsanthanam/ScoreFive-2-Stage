//
//  HomeInteractorTests.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 2/2/21.
//

import Combine
import Foundation
@testable import ScoreFive
@testable import ShortRibs
import XCTest

final class HomeInteractorTests: TestCase {
    
    let presenter = HomePresentableMock()
    let listener = HomeListenerMock()
    let gameStorageManager = GameStorageManagingMock()
    let newGameBuilder = NewGameBuildableMock()
    
    var interactor: HomeInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           gameStorageManager: gameStorageManager,
                           newGameBuilder: newGameBuilder)
        interactor.listener = listener
    }
    
    func test_activate_noGames_hidesResumeButton() {
        gameStorageManager.fetchGameRecordsHandler = { [] }
        XCTAssertEqual(presenter.hideResumeButtonCallCount, 0)
        interactor.activate()
        XCTAssertEqual(presenter.hideResumeButtonCallCount, 1)
    }
}
