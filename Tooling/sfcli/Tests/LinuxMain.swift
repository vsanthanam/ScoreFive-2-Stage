import XCTest

import sfcliTests

var tests = [XCTestCaseEntry]()
tests += sfcliTests.allTests()
XCTMain(tests)
