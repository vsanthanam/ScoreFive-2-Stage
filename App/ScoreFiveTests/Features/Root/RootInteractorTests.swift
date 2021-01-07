//
//  RootInteractorTests.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
@testable import ScoreFive
@testable import ShortRibs
import XCTest

final class RootInteractorTests: XCTestCase {

    let presenter = RootPresentableMock()
    let mainBuilder = MainBuildableMock()

    var interactor: RootInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter, mainBuilder: mainBuilder)
    }

    func test_init_setsPresenterListener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_activate_routesToMain() {
        mainBuilder.buildHandler = { listener in
            XCTAssertTrue(listener === self.interactor)
            return PresentableInteractableMock()
        }

        XCTAssertEqual(mainBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showMainCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()

        XCTAssertEqual(mainBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showMainCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }
}
