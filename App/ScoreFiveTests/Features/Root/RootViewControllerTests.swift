//
//  RootViewControllerTests.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
@testable import ScoreFive
@testable import ShortRibs
import XCTest

final class RootViewControllerTests: XCTestCase {
    
    let listener = RootPresentableListenerMock()
    let viewController = RootViewController()
    
    override func setUp() {
        viewController.listener = listener
    }
    
    func test_showMain() {
        let vc1 = ViewControllableMock(uiviewController: .init())
        let vc2 = ViewControllableMock(uiviewController: .init())
        
        XCTAssertEqual(viewController.children.count, 0)
        viewController.showMain(vc1)
        XCTAssertEqual(viewController.children.count, 1)
        viewController.showMain(vc2)
        XCTAssertEqual(viewController.children.count, 1)
    }
}
