//
//  TestCase.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 1/6/21.
//

import Combine
import Foundation
import XCTest

class TestCase: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        cancellables.forEach { cancellable in cancellable.cancel() }
        super.tearDown()
    }
}

extension Cancellable {
    func cancelOnTearDown(testCase: TestCase) {
        store(in: &testCase.cancellables)
    }
}
