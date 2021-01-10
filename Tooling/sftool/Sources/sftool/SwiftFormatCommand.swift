//
//  File.swift
//  
//
//  Created by Varun Santhanam on 1/10/21.
//

import ArgumentParser
import Foundation
import ShellOut

struct SwiftFormatCommand: ParsableCommand {

    // MARK: - Initializers
    
    init() {}
    
    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "format", abstract: "Run swiftformat")

    func run() throws {
        let configuration = try fetchConfiguration(on: root)
        do {
            try runSwiftFormat(with: configuration)
            print("Process Complete! 🍻")
        } catch {
            print("Formatting Failed: \((error as! ShellOutError).message)")
            throw error
        }
    }

    // MARK: - API

    @Flag(name: .shortAndLong, help: "Display verbose logging")
    var verbose: Bool = false
    
    @Option(name: .shortAndLong, help: "Location of the score five repo")
    var root: String = FileManager.default.currentDirectoryPath
    
    private func runSwiftFormat(with configuration: Configuration) throws {
        var configComponents: [String] = .init()
        if configuration.swiftformat.disableRules.count > 0 {
            let disable = "--disable" + " " + configuration.swiftformat.disableRules.joined(separator: ",")
            configComponents.append(disable)
            
        }
        if configuration.swiftformat.enableRules.count > 0 {
            let enable = "--enable" + " " + configuration.swiftformat.enableRules.joined(separator: ",")
            configComponents.append(enable)
        }
        
        let exclude = [configuration.vendorCodePath] + [configuration.diGraphPath] + [configuration.mockPath] + configuration.swiftformat.excludeDirs
        
        exclude.forEach { exclude in
            let component = "--excude" + " " + exclude
            configComponents.append(component)
        }
        
        let swiftformat = configComponents.joined(separator: "\n")
        let echo = "echo \"\(swiftformat)\" >> .swiftformat"
        try shellOut(to: echo)
        let configToUse = try shellOut(to: .readFile(at: root + "/.swiftformat"))
        if verbose {
            print("SwiftFormat Config:")
            print(configToUse)
        }
        print("Formatting files...")
        try shellOut(to: "swiftformat " + root)
        try shellOut(to: .removeFile(from: root + "/.swiftformat"))
    }
}
