import XCTest

import sftoolTests

var tests = [XCTestCaseEntry]()
tests += sftoolTests.allTests()
XCTMain(tests)
