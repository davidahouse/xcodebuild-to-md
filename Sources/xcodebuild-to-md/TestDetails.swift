//
//  TestDetails.swift
//  Chute
//
//  Created by David House on 7/6/19.
//  Copyright © 2019-2023 repairward. All rights reserved.
//

import Foundation
import XCResultKit

struct TestClass: Identifiable {
    let id: String
    let className: String
    let testCases: [TestCase]
}

struct TestCase: Identifiable {
    let id: String
    let testName: String
    let status: String
    let failureMessage: String?
}

struct TestDetails {
    
    var classes: [TestClass] = []
    var allTests: [ActionTestMetadata] = []
    
    mutating func updateSummaries(_ summaries: [ActionTestPlanRunSummary], issues: ResultIssueSummaries) {
        let tests = gatherTests(summaries: summaries)
        allTests = tests
        
        // get the class names
        var classNames = Set<String>()
        for test in tests {
            guard let identifier = test.identifier else { fatalError("test.identifier is nil") }

            let parts = identifier.split(separator: "/")
            classNames.insert(String(parts[0]))
        }

        var gathered = [TestClass]()
        for testClass in classNames {
            let testsForClass = tests.filter {
                guard let identifier = $0.identifier else { return false }
                return identifier.hasPrefix(testClass)
            }
            gathered.append(TestClass(
                id: testClass,
                className: testClass,
                testCases: testsForClass.map {
                    TestCase(
                        id: $0.name ?? String("(noname)"),
                        testName: $0.name ?? String("(noTestName)"),
                        status: $0.testStatus,
                        failureMessage: failureMessageFor(test: $0, in: issues))}))
        }
        classes = gathered
    }
    
    func gatherTests(summaries: [ActionTestPlanRunSummary]) -> [ActionTestMetadata] {
        var foundTests = [ActionTestMetadata]()
        for summary in summaries {
            for testableSummary in summary.testableSummaries {
                for testGroup in testableSummary.tests {
                    foundTests += gatherTests(group: testGroup)
                }
            }
        }
        return foundTests
    }
    
    func gatherTests(group: ActionTestSummaryGroup) -> [ActionTestMetadata] {
        var tests = group.subtests
        for group in group.subtestGroups {
            tests += gatherTests(group: group)
        }
        return tests
    }
    
    func failureMessageFor(test: ActionTestMetadata, in issues: ResultIssueSummaries) -> String? {
        let testClassName = (test.identifier?.split(separator: "/")[0])
        let testCaseName = (test.identifier?.split(separator: "/")[1])

        guard let testClassName = testClassName else { return nil }
        guard let testCaseName = testCaseName else { return nil }

        for testFailure in issues.testFailureSummaries {
            if testFailure.testCaseName == testClassName + "." + testCaseName {
                return testFailure.message
            }
        }

        return nil
    }
}
