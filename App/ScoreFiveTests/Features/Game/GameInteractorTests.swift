//
//  GameInteractorTests.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 2/10/21.
//

import Combine
import Foundation
@testable import ScoreFive
import ScoreKeeping
@testable import ShortRibs
import XCTest

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
        activeGameStream.activeGameIdentifier = CurrentValueSubject<UUID?, Never>(nil).eraseToAnyPublisher()
        gameStorageManager.scoreCardHandler = { _ in
            CurrentValueSubject<ScoreCard?, Never>(nil).eraseToAnyPublisher()
        }
    }

    func test_activate_attachesScoreCard() {
        scoreCardBuilder.buildHandler = { listener in
            XCTAssertTrue(listener === self.interactor)
            return ScoreCardInteractableMock()
        }

        XCTAssertEqual(scoreCardBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showScoreCardCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()

        XCTAssertEqual(scoreCardBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showScoreCardCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

    func test_activate_startsUpdatingTitles() {
        let identifier = UUID()
        activeGameStream.activeGameIdentifier = CurrentValueSubject<UUID?, Never>(identifier).eraseToAnyPublisher()
        gameStorageManager.scoreCardHandler = { id in
            XCTAssertEqual(id, identifier)
            let card = ScoreCard(orderedPlayers: ["Player 1", "Player 2"].map(Player.init))
            return CurrentValueSubject<ScoreCard?, Never>(card).eraseToAnyPublisher()
        }

        presenter.updateHeaderTitlesHandler = { titles in
            XCTAssertEqual(titles, ["P", "P"])
        }

        presenter.updateTotalScoresHandler = { scores in
            XCTAssertEqual(scores, ["0", "0"])
        }

        XCTAssertEqual(presenter.updateHeaderTitlesCallCount, 0)
        XCTAssertEqual(presenter.updateTotalScoresCallCount, 0)

        interactor.activate()

        XCTAssertEqual(presenter.updateHeaderTitlesCallCount, 1)
        XCTAssertEqual(presenter.updateTotalScoresCallCount, 1)
    }

    func test_routeToGameSettings() {
        let gameSettings = PresentableInteractableMock()
        gameSettingsBuilder.buildHandler = { listener in
            XCTAssertTrue(listener === self.interactor)
            return gameSettings
        }

        XCTAssertEqual(interactor.children.count, 0)
        XCTAssertEqual(presenter.showGameSettingsCallCount, 0)
        XCTAssertEqual(presenter.closeGameSettingsCallCount, 0)
        XCTAssertEqual(gameSettingsBuilder.buildCallCount, 0)

        interactor.wantGameSettings()

        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertEqual(presenter.showGameSettingsCallCount, 1)
        XCTAssertEqual(presenter.closeGameSettingsCallCount, 0)
        XCTAssertEqual(gameSettingsBuilder.buildCallCount, 1)

        gameSettings.isActive = true

        interactor.gameSettingsDidResign()

        XCTAssertEqual(interactor.children.count, 0)
        XCTAssertEqual(presenter.showGameSettingsCallCount, 1)
        XCTAssertEqual(presenter.closeGameSettingsCallCount, 1)
        XCTAssertEqual(gameSettingsBuilder.buildCallCount, 1)
    }

    func test_routeToNewRound_noReplacement_cancel() {
        let newRound = PresentableInteractableMock()
        newRoundBuilder.buildHandler = { listener, _, _ in
            XCTAssertTrue(listener === self.interactor)
            return newRound
        }

        XCTAssertEqual(interactor.children.count, 0)
        XCTAssertEqual(presenter.showNewRoundCallCount, 0)
        XCTAssertEqual(presenter.closeNewRoundCallCount, 0)
        XCTAssertEqual(newRoundBuilder.buildCallCount, 0)

        interactor.wantNewRound()

        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertEqual(presenter.showNewRoundCallCount, 1)
        XCTAssertEqual(presenter.closeNewRoundCallCount, 0)
        XCTAssertEqual(newRoundBuilder.buildCallCount, 1)

        newRound.isActive = true

        interactor.newRoundDidCancel()

        XCTAssertEqual(interactor.children.count, 0)
        XCTAssertEqual(presenter.showNewRoundCallCount, 1)
        XCTAssertEqual(presenter.closeNewRoundCallCount, 1)
        XCTAssertEqual(newRoundBuilder.buildCallCount, 1)
    }

    func test_saveNewRound() {
        let newRound = PresentableInteractableMock()

        newRoundBuilder.buildHandler = { listener, _, _ in
            XCTAssertTrue(listener === self.interactor)
            return newRound
        }

        XCTAssertEqual(interactor.children.count, 0)
        XCTAssertEqual(presenter.showNewRoundCallCount, 0)
        XCTAssertEqual(presenter.closeNewRoundCallCount, 0)
        XCTAssertEqual(newRoundBuilder.buildCallCount, 0)

        interactor.wantNewRound()

        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertEqual(presenter.showNewRoundCallCount, 1)
        XCTAssertEqual(presenter.closeNewRoundCallCount, 0)
        XCTAssertEqual(newRoundBuilder.buildCallCount, 1)

        newRound.isActive = true
        let identifier = UUID()
        activeGameStream.currentActiveGameIdentifier = identifier
        let card = ScoreCard(orderedPlayers: ["Player 1", "Player 2"].map(Player.init))
        gameStorageManager.fetchScoreCardHandler = { id in
            XCTAssertEqual(id, identifier)
            return card
        }

        XCTAssertEqual(card.rounds.count, 0)

        var round = Round()
        for i in 0 ..< card.orderedPlayers.count {
            round[card.orderedPlayers[i]] = i
        }

        XCTAssertEqual(gameStorageManager.fetchScoreCardCallCount, 0)
        XCTAssertEqual(gameStorageManager.saveCallCount, 0)

        interactor.newRoundDidAddRound(round)

        XCTAssertEqual(gameStorageManager.fetchScoreCardCallCount, 1)
        XCTAssertEqual(gameStorageManager.saveCallCount, 1)

        XCTAssertEqual(interactor.children.count, 0)
        XCTAssertEqual(presenter.showNewRoundCallCount, 1)
        XCTAssertEqual(presenter.closeNewRoundCallCount, 1)
        XCTAssertEqual(newRoundBuilder.buildCallCount, 1)
    }

}

private extension Player {
    init(_ name: String) {
        self.init(name: name, uuid: .init())
    }
}
