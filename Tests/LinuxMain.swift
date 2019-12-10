import XCTest

import xcodebuild_to_mdTests

var tests = [XCTestCaseEntry]()
tests += xcodebuild_to_mdTests.allTests()
XCTMain(tests)
