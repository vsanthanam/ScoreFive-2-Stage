//
//  File.swift
//
//
//  Created by Varun Santhanam on 2/20/21.
//

import ArgumentParser
import Foundation
import ShellOut

struct TestCommand: ParsableCommand {

    // MARK: - Initializers

    init() {}

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "test",
                                                    abstract: "Run Unit Tests")

    @Option(name: .shortAndLong, help: "Location of the score five repo")
    var root: String = FileManager.default.currentDirectoryPath

    @Option(name: .shortAndLong, help: "Simulator Device Name")
    var device: String?

    @Option(name: .shortAndLong, help: "Simulator Version")
    var os: String?

    func run() throws {
        let configuration = try fetchConfiguration(on: root)
        let device = self.device ?? configuration.testConfig.device
        let os = self.os ?? configuration.testConfig.os
        print("Running tests on \(device) running \(os)")
        print("This might take a few minutes")
        do {
            let results = try Commands.runTests(root, name: device, os: os)
            print(results)
            print("Tests Complete! 🍻")
        } catch {
            print("\((error as! ShellOutError).message)")
            throw error
        }
    }
}
