//
//  SummaryOutput.swift
//  xcodebuild-to-md
//
//  Created by David House on 11/25/19.
//  Copyright © 2019 davidahouse. All rights reserved.
//

import Foundation

func summaryOutput(findings: [String: CompileFindings], testSummary: TestSummary) {
    
    print("### xcodebuild Summary:")
    print(" ")
    
    var warnings = 0
    var errors = 0
    
    for (_, finding) in findings {
        for finding in finding.findings {
            switch finding.category {
            case .error:
                errors += 1
            case .warning:
                warnings += 1
            }
        }
    }
    
    print("- :heavy_exclamation_mark: \(errors) Error(s)")
    print("- :warning: \(warnings) Warning(s)")
    print(" ")
    print("### Testing Summary: ")
    print("- \(testSummary.allTests) Total test(s)")
    print("- \(testSummary.successTests) Successful test(s)")
    print("- \(testSummary.failedTests) Failed test(s)")
    if let coverage = testSummary.codeCoverage {
        let totalCoverage = Int(coverage.lineCoverage * 100.0)
        print("- Code Coverage is \(totalCoverage)%")
    }
}
