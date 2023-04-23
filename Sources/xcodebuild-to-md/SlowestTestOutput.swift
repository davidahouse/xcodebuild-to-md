//
//  SlowestTextOutput.swift
//  xcodebuild-to-md
//
//  Created by Steven Woolgar on 01/19/2023.
//  Copyright © 2023 davidahouse. All rights reserved.
//

import Foundation

func slowestTestsOutput(
    testSummary: TestSummary,
    slowTestCount: Int
) {
    print(" ")
    print("### \(slowTestCount) Slowest Tests:")
    print("|Test name|Test duration|")
    print("|:----|:----|")

    let testsWithDurations = testSummary.details.allTests.filter { $0.duration != nil }
    let testsSortedByDuration = testsWithDurations.sorted {
        guard let duration0 = $0.duration, let duration1 = $1.duration else { fatalError("nil duractions should not happen here") }
        return duration0 > duration1
    }

    for test in testsSortedByDuration.prefix(upTo: min(slowTestCount, testsSortedByDuration.count)) {
        guard let duration = test.duration else { continue }
        print("|\(test.name ?? String("<no name test>"))|\(String(format: "%.02f", duration))|")
    }
    print(" ")
}
