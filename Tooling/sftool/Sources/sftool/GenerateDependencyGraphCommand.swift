//
//  File.swift
//
//
//  Created by Varun Santhanam on 1/9/21.
//

import ArgumentParser
import Foundation
import ShellOut

enum DepsError: Error {
    case needle(_ error: ShellOutError)

    var shellOutError: ShellOutError {
        switch self {
        case let .needle(error):
            return error
        }
    }
}

struct GenerateDependencyGraphCommand: ParsableCommand {
    
    // MARK: - Initializers
    
    init() {}

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "deps",
                                                    abstract: "Generate DI Graph with Needle")

    func run() throws {
        let configuration = try fetchConfiguration(on: root)
        do {
            try generateDependencyGraph(with: configuration)
            print("Process Complete! 🍻")
        } catch {
            print("Needle Failed: \((error as! ShellOutError).message)")
            throw error
        }
    }
    
    // MARK: - API
    
    @Option(name: .shortAndLong, help: "Location of the score five repo")
    var root: String = FileManager.default.currentDirectoryPath
    
    @Flag(name: .shortAndLong, help: "Verbose Logging")
    var verbose: Bool = false
    
    // MARK: - Private
    
    private func generateDependencyGraph(with configuration: Configuration) throws {
        let needleInput = root + configuration.diCodePath
        let dependencyGraph = root + configuration.diGraphPath
        if verbose {
            print("Input Paths:")
            print(needleInput)
            print("Output Path:")
            print(dependencyGraph)
        }
        let command = "export SOURCEKIT_LOGGING=0 && needle generate \(dependencyGraph) \(needleInput)"
        if verbose {
            print("Running command \(command)")
        }
        try shellOut(to: command)
    }

}
