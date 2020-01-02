//
//  TextOutput.swift
//  xcodebuild-to-md
//
//  Created by David House on 11/25/19.
//  Copyright © 2019 davidahouse. All rights reserved.
//

import Foundation

func textOutput(findings: [String: CompileFindings], testSummary: TestSummary, includeWarnings: Bool) {
    
    print("### xcodebuild Findings:")
    print(" ")

    var foundFindings = false
    for (fileName, finding) in findings {
        for finding in finding.findings {
            if (finding.category == .error) || (includeWarnings == true) {
                print("\(fileName) (\(finding.line):\(finding.column))")
                print(" ")
                print("```")
                print(codeLine(from: fileName, line: finding.line))
                print(String.init(repeating: " ", count: finding.column) + "^")
                print("```")
                if (finding.category == .error) {
                    print("> :heavy_exclamation_mark: \(finding.message)")
                } else {
                    print("> :warning: \(finding.message)")
                }
                print(" ")
                foundFindings = true
            }
        }
    }
    
    if !foundFindings && (includeWarnings == true) {
        print("No compiler errors or warnings, great job!")
    }
    
    
    print(" ")
    print("### Test failures: ")
    print(" ")
    
    var foundFailedTests = false
    var foundTests = 0
    for testClass in testSummary.details.classes {
        for testCase in testClass.testCases {
            if testCase.status == "Failure" {
                print(":heavy_exclamation_mark: *\(testClass.className)* \(testCase.id)")
                if let message = testCase.failureMessage {
                    print("> \(message)")
                }
                print(" ")
                foundFailedTests = true
            }
            foundTests += 1
        }
    }

    if foundTests > 0 {
        if !foundFailedTests {
            print("No failing tests, awesome!")
        }
    } else {
        print("No tests found at all! Check for compile errors.")
    }
}

func codeLine(from fileName: String, line: Int) -> String {
    
    do {
        let url = URL(fileURLWithPath: fileName)
        let contents = try Data(contentsOf: url)
        if let fileContents = String(data: contents, encoding: .utf8)?.components(separatedBy: .newlines) {
            if line < fileContents.count {
                return String(fileContents[line])
            } else {
                return ""
            }
        } else {
            return ""
        }
    } catch {
        return ""
    }
}
