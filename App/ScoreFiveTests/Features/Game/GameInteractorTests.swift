//
//  GameInteractorTests.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 2/10/21.
//

import Foundation
import XCTest
@testable import ScoreFive
@testable import ShortRibs

final class GameInteractorTests: TestCase {
    
    let listener = GameListenerMock()
    let presenter = GamePresentableMock()
    let gameStorageManager = GameStorageManagingMock()
    let activeGameStream = ActiveGameStreamingMock()
    let newRoundBuilder = NewRoundBuildableMock()
    let scoreCardBuilder = ScoreCardBuildableMock()
    let gameSettingsBuilder = GameSettingsBuildableMock()
    
    var interactor: GameInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           gameStorageManager: gameStorageManager,
                           activeGameStream: activeGameStream,
                           newRoundBuilder: newRoundBuilder,
                           scoreCardBuilder: scoreCardBuilder,
                           gameSettingsBuilder: gameSettingsBuilder)
        interactor.listener = listener
    }
    
}
