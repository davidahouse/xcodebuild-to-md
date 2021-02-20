//
//  File.swift
//  
//
//  Created by David House on 2/20/21.
//

import Foundation

func badgeOutput(findings: [String: CompileFindings], testSummary: TestSummary) {
    
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
    
    if errors > 0 {
        print("- ![errors](https://img.shields.io/badge/Compile%20Errors-\(errors)-critical)")
    }

    if warnings > 0 {
        print("- ![warnings](https://img.shields.io/badge/Compile%20Warnings-\(warnings)-yellow)")
    }
    
    print("- ![totaltests](https://img.shields.io/badge/Unit%20Test%20Count-\(testSummary.allTests)-informational)")
    print("- ![successtests](https://img.shields.io/badge/Unit%20Test%20Count-\(testSummary.successTests)-success)")
    print("- ![failedtests](https://img.shields.io/badge/Unit%20Test%20Count-\(testSummary.failedTests)-critical)")

    if let coverage = testSummary.codeCoverage {
        let totalCoverage = Int(coverage.lineCoverage * 100.0)
        if totalCoverage <= 50 {
            print("- ![coverage](https://img.shields.io/badge/Code%20Coverage-\(totalCoverage)%25-critical)")
        } else if totalCoverage < 70 {
            print("- ![coverage](https://img.shields.io/badge/Code%20Coverage-\(totalCoverage)%25-yellow)")
        } else if totalCoverage < 90 {
            print("- ![coverage](https://img.shields.io/badge/Code%20Coverage-\(totalCoverage)%25-yellowgreen)")
        } else {
            print("- ![coverage](https://img.shields.io/badge/Code%20Coverage-\(totalCoverage)%25-success)")
        }
    }
}
