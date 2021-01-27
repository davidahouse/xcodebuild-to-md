//
//  DerivedData.swift
//  Chute
//
//  Created by David House on 7/3/19.
//  Copyright © 2019 repairward. All rights reserved.
//

import Foundation
import XCResultKit

class DerivedData {
    
    var debug: Bool = false
    var root: Bool = false
    var location: URL? {
        didSet {
            testResultFiles = self.findTestResultFiles()
        }
    }
    var testResultFiles: [XCResultFile] = []
    
    func recentResultFile() -> XCResultFile? {
        // TODO: eventually sort by date/time, but for now just pick one
        if debug {
            print("DEBUG: Picking first file from \(testResultFiles.count) found")
        }
        if testResultFiles.count > 0 {
            return testResultFiles[testResultFiles.count - 1]
        } else {
            return nil
        }
    }
    
    private func findTestResultFiles() -> [XCResultFile] {
        
        guard let location = location else {
            if debug {
                print("DEBUG: Derived Data Location was nil so unable to continue")
            }
            return []
        }
        
        let folders: [String] = {
            guard root == false else {
                return [location.path]
            }
            
            guard let folders = try? FileManager.default.contentsOfDirectory(atPath: location.path) else {
                if debug {
                    print("DEBUG: Error getting contents of derived data folder \(location.path)")
                }
                return []
            }
            return folders
        }()
        
        var found: [URL] = []
        for folder in folders {
            let folderURL: URL = {
                if root {
                    return location.appendingPathComponent("Logs").appendingPathComponent("Test")
                } else {
                    return location.appendingPathComponent(folder).appendingPathComponent("Logs").appendingPathComponent("Test")
                }
            }()
            if FileManager.default.fileExists(atPath: folderURL.path, isDirectory: nil) {
                if let allFiles = try? FileManager.default.contentsOfDirectory(atPath: folderURL.path) {
                    if debug {
                        print("DEBUG: found \(allFiles.count) files in the Logs/Test subfolder")
                    }
                    found += allFiles.filter { $0.hasSuffix(".xcresult") }.map { folderURL.appendingPathComponent($0) }
                } else {
                    if debug {
                        print("DEBUG: Error getting contents of Logs/Test folder")
                    }
                }
            } else {
                if debug {
                    print("DEBUG: Unable to find Logs/Test subfolder at \(folderURL)")
                }
            }
        }
        
        if debug {
            for file in found {
                print("DEBUG: Found \(file)")
            }
        }
        
        return found.sorted { (lhs, rhs) -> Bool in
            lhs.lastPathComponent < rhs.lastPathComponent
        }.map { XCResultFile(url: $0) }
    }
}
