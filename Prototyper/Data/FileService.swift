//
//  Unzipper.swift
//  Prototyper
//
//  Created by Ерохин Ярослав Игоревич on 03.11.2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation
import ZIPFoundation

// File system:
// files/{name}/data.json
// files/{name}/images/{image}.png

enum FileService {
    
    private static let filesPath = "files"
    
    private static let manager = FileManager.default
    private static let documentsUrl = manager.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
    
    static func canCreateFolder(for name: String) -> Bool {
        let url = documentsUrl.appendingPathComponent("\(filesPath)/\(name)")
//        if !manager.fileExists(atPath: url.path) {
            do {
                try manager.createDirectory(at: url,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
                return true
            }
            catch {
                print(error)
                return false
            }
//        }
//        return true // replace existing
    }
    
    static func importFile(_ url: URL) -> Bool {
        guard let name = url.lastPathComponent.components(separatedBy: ".").first
            else { return false }
        
        // check name

        if canCreateFolder(for: name) {
            if url.path.hasSuffix("json") {
                
                let path = "\(filesPath)/\(name)/data.json"
                let fileUrl = documentsUrl.appendingPathComponent(path)
                
                do {
                    try manager.moveItem(at: url, to: fileUrl)
                    return true
                }
                catch {
                    print(error)
                    return false
                }
            }
            else if url.path.hasSuffix("zip") {
                
                do {
                    let dirUrl = documentsUrl.appendingPathComponent(filesPath)
                    let temp = getCacheDir()
                    try manager.unzipItem(at: url, to: temp)
                    
                    let allFiles = try manager.contentsOfDirectory(atPath: temp.path)
                    for file in allFiles {
                        if file == "__MACOSX" { continue }
                        
                        let oldUrl = temp.appendingPathComponent(file)
                        let newUrl = dirUrl.appendingPathComponent(file)
                        if manager.fileExists(atPath: newUrl.path) {
                            try manager.removeItem(at: newUrl)
                        }
                        
                        try manager.moveItem(atPath: oldUrl.path, toPath: newUrl.path)
                    }
                    
                    return true
                }
                catch {
                    print(error)
                    return false
                }
            }
        }
        
        return false
    }
    
    static func loadFile(at path: String) -> Data? {
        manager.contents(atPath: path)
    }
    
    private static func getCacheDir() -> URL {
        let temp = manager.urls(for: .cachesDirectory,
                                in: .userDomainMask).first!
        
        let allFiles = try? manager.contentsOfDirectory(atPath: temp.path)
        if let files = allFiles {
            for file in files {
                let fileUrl = temp.appendingPathComponent(file)
                try? manager.removeItem(at: fileUrl)
            }
        }
        return temp
    }
    
    static func removeAll() {
        do {
            let url = documentsUrl.appendingPathComponent(filesPath)
            try manager.removeItem(at: url)
        }
        catch {
            print(error)
        }
    }
    
    static func getList() -> [(String, URL)] {
        let dirUrl = documentsUrl.appendingPathComponent(filesPath)
        do {
            let names = try manager.contentsOfDirectory(atPath: dirUrl.path)
            return names.map { ($0, dirUrl.appendingPathComponent($0)) }
        }
        catch {
            print(error)
            return []
        }
    }
    
    private static func listFiles(at path: String, level: Int = 0) {
        let prefix = Array(0..<level).map { _ in return "-" }
            .joined().trimmingCharacters(in: .whitespaces)
        let fileUrl = URL(fileURLWithPath: path)
        
        do {
            let files = try manager.contentsOfDirectory(atPath: fileUrl.path)
            
            files.forEach { file in
                let url = fileUrl.appendingPathComponent(file)
                
                var isDirectory = ObjCBool(booleanLiteral: false)
                manager.fileExists(atPath: url.path, isDirectory: &isDirectory)
                if isDirectory.boolValue {
                    if level == 0 { print("\n\(file):") }
                    else { print("\(prefix) \(file):") }
                    listFiles(at: url.path, level: level+1)
                }
                else {
                    print("\(prefix) \(file)")
                }
            }
        }
        catch { }
    }
}
