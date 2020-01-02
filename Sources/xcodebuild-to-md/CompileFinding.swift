//
//  CompileFinding.swift
//  xcodebuild-to-md
//
//  Created by David House on 11/25/19.
//  Copyright © 2019 davidahouse. All rights reserved.
//

import Foundation
import XCResultKit

enum CompileFindingCategory {
    case error
    case warning
}

struct CompileFinding {
    let category: CompileFindingCategory
    let type: String
    let message: String
    let column: Int
    let line: Int
}

struct CompileFindings {
    let fileName: String
    let findings: [CompileFinding]
}

func gatherFindings(from resultKit: XCResultFile, path: String) -> [String: CompileFindings] {
    
    var findings: [String: CompileFindings] = [:]

    guard let invocationRecord = resultKit.getInvocationRecord() else {
        print("Unable to find invocation record in XCResult file!")
        exit(1)
    }

    for action in invocationRecord.actions {
        for error in action.buildResult.issues.errorSummaries {
            if let location = error.documentLocationInCreatingWorkspace {
                
                let locationParts = location.url.split(separator: "#")
                let locationURL = URL(fileURLWithPath: String(locationParts[0]))
                let fileName = locationURL.path.replacingOccurrences(of: path + "/", with: "").replacingOccurrences(of: "file:", with: "")
                
                let locationDetails = locationParts[1].split(separator: "&")
                var column = 0
                var line = 0
                for detail in locationDetails {
                    let detailParts = detail.split(separator: "=")
                    switch detailParts[0] {
                    case "StartingColumnNumber":
                        column = Int(String(detailParts[1])) ?? 0
                    case "StartingLineNumber":
                        line = Int(String(detailParts[1])) ?? 0
                    default:
                        break
                    }
                }
                
                if let found = findings[fileName] {
                    let existing = found.findings.filter {
                        $0.message == error.message && $0.type == error.issueType
                    }
                    if existing.count == 0 {
                        findings[fileName] = CompileFindings(fileName: fileName, findings: found.findings + [CompileFinding(category: .error, type: error.issueType, message: error.message, column: column, line: line)])
                    }
                } else {
                    findings[fileName] = CompileFindings(fileName: fileName, findings: [CompileFinding(category: .error, type: error.issueType, message: error.message, column: column, line: line)])
                }
            }
        }
        
        for warning in action.buildResult.issues.warningSummaries {
            if let location = warning.documentLocationInCreatingWorkspace {
                
                let locationParts = location.url.split(separator: "#")
                let locationURL = URL(fileURLWithPath: String(locationParts[0]))
                let fileName = locationURL.path.replacingOccurrences(of: path + "/", with: "").replacingOccurrences(of: "file:", with: "")
                
                let locationDetails = locationParts[1].split(separator: "&")
                var column = 0
                var line = 0
                for detail in locationDetails {
                    let detailParts = detail.split(separator: "=")
                    switch detailParts[0] {
                    case "StartingColumnNumber":
                        column = Int(String(detailParts[1])) ?? 0
                    case "StartingLineNumber":
                        line = Int(String(detailParts[1])) ?? 0
                    default:
                        break
                    }
                }
                
                if let found = findings[fileName] {
                    let existing = found.findings.filter {
                        $0.message == warning.message && $0.type == warning.issueType
                    }
                    if existing.count == 0 {
                        findings[fileName] = CompileFindings(fileName: fileName, findings: found.findings + [CompileFinding(category: .warning, type: warning.issueType, message: warning.message, column: column, line: line)])
                    }
                } else {
                    findings[fileName] = CompileFindings(fileName: fileName, findings: [CompileFinding(category: .warning, type: warning.issueType, message: warning.message, column: column, line: line)])
                }
            }
        }
    }
    return findings
}
