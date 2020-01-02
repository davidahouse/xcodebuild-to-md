//
//  main.swift
//  xcodebuild-to-md
//
//  Created by David House on 11/25/19.
//  Copyright © 2019 davidahouse. All rights reserved.
//

import Foundation
import XCResultKit

let commandLine = CommandLineArguments()
guard let path = commandLine.derivedDataFolder else {
    print("-derivedDataFolder is required, unable to continue")
    exit(1)
}


let derivedData = DerivedData()
derivedData.location = URL(fileURLWithPath: path)
guard let resultKit = derivedData.recentResultFile() else {
    print("Unable to find XCResult file!")
    exit(1)
}

// Gather up any compiler errors & warnings
let findings = gatherFindings(from: resultKit, path: path)

// Now see if there are test summaries
let testSummary = gatherTestSummary(from: resultKit)

if (commandLine.output?.lowercased() == "summary") {
    summaryOutput(findings: findings, testSummary: testSummary)
} else {
    textOutput(findings: findings, testSummary: testSummary, includeWarnings: commandLine.includeWarnings)
}
