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
    
    var interactor: FiveInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
    }
    
    func test_init_setsPresenterListener() {
        XCTAssertTrue(presenter.listener === self.interactor)
    }
}


