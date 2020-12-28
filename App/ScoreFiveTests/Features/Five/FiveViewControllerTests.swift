//
//  FiveViewControllerTests.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation

import Foundation
@testable import ScoreFive
@testable import ShortRibs
import XCTest

final class FiveViewControllerTests: XCTestCase {
    
    let listener = FivePresentableListenerMock()
    let viewController = FiveViewController()
    
    override func setUp() {
        viewController.listener = listener
    }
}
