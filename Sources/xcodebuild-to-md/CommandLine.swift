//
//  CommandLine.swift
//  xcodebuild-to-md
//
//  Created by David House on 9/10/17.
//  Copyright © 2017 David House. All rights reserved.
//

//
//  xcodebuild-to-md
//      -derivedDataFolder      The folder that the code was built into
//      -output                 The type of output (summary or text)
//      -repositoryURL          The URL for the repository
//      -sha                    The sha of the code that was compiled
//      -includeWarnings        If text output should include compiler warnings
//      -debug                  Set to enable debug mode which will log out more details about the attempt
import Foundation

struct CommandLineArguments {

    let derivedDataFolder: String?
    let output: String?
    let repositoryURL: String?
    let sha: String?
    let includeWarnings: Bool
    let debug: Bool
    let root: Bool

    init(arguments: [String] = CommandLine.arguments) {

        var foundArguments: [String: String] = [:]
        for (index, value) in arguments.enumerated() {

            if value.hasPrefix("-") && index < (arguments.count - 1) && !arguments[index+1].hasPrefix("-") {
                let parameter = String(value.suffix(value.count - 1))
                foundArguments[parameter] = arguments[index+1]
            }
        }
        
        derivedDataFolder = foundArguments["derivedDataFolder"]
        output = foundArguments["output"]
        repositoryURL = foundArguments["repositoryURL"]
        sha = foundArguments["sha"]
        if foundArguments["includeWarnings"]?.lowercased() == "false" || foundArguments["includeWarnings"]?.lowercased() == "no" {
            includeWarnings = false
        } else {
            includeWarnings = true
        }
        if foundArguments["debug"]?.lowercased() == "true" || foundArguments["debug"]?.lowercased() == "yes" {
            debug = true
        } else {
            debug = false
        }
        if foundArguments["root"]?.lowercased() == "true" || foundArguments["root"]?.lowercased() == "yes" {
            root = true
        } else {
            root = false
        }
    }

    func printInstructions() {
        var instructions = "Usage: xcodebuild-to-md -derivedDataFolder <path>"
        instructions += " [-output <summary/text/badges>]"
        instructions += " [-repositoryURL <url>]"
        instructions += " [-sha <string>]"
        instructions += " [-debug true/false]"
        instructions += " [-root true/false]"
        print(instructions)
    }
}
