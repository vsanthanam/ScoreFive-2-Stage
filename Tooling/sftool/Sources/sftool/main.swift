import ArgumentParser
import Foundation
import ShellOut

struct sftool: ParsableCommand {
    
    // MARK: - Initializers
    
    init() {}
    
    // MARK: - ParsableCommand
    
    static let configuration = CommandConfiguration(
        abstract: "A command line utility for the ScoreFive iOS repo",
        subcommands: [Format.self, Gen.self]
    )
}

struct Gen: ParsableCommand {

    // MARK: - Initializers
    
    init() {}
    
    // MARK: - ParsableCommand
    
    static let configuration = CommandConfiguration(
        abstract: "Generate code",
        subcommands: [Mocks.self, Deps.self]
    )
}

struct Format: ParsableCommand {

    // MARK: - Initializers
    
    init() {}
    
    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(abstract: "Run swiftformat")

    func run() throws {
        do {
            try swiftFormat(verbose: verbose, root: root)
            print("Process Complete! 🍻")
        } catch {
            print("An error occured: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - API

    @Flag(name: .shortAndLong, help: "Display verbose logging")
    var verbose: Bool = false
    
    @Option(name: .shortAndLong, help: "Location of the score five repo")
    var root: String = FileManager.default.currentDirectoryPath

}

struct Mocks: ParsableCommand {

    // MARK: - Initializers
    
    init() {}
    
    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(abstract: "Generate Mocks with Mockolo")

    func run() throws {
        do {
            try runMockolo(root: root)
            print("Process Complete! 🍻")
        } catch {
            print("An error occured: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - API
    
    @Option(name: .shortAndLong, help: "Location of the score five repo")
    var root: String = FileManager.default.currentDirectoryPath

}

struct Deps: ParsableCommand {
    
    // MARK: - Initializers
    
    init() {}

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(abstract: "Generate DI Graph with Needle")

    func run() throws {
        do {
            try runNeedle(root: root)
            print("Process Complete! 🍻")
        } catch {
            if let error = error as? DepsError {
                print("An error occured: \(error.shellOutError.message)")
            }
            throw error
        }
    }
    
    // MARK: - API
    
    @Option(name: .shortAndLong, help: "Location of the score five repo")
    var root: String = FileManager.default.currentDirectoryPath

}

sftool.main()
