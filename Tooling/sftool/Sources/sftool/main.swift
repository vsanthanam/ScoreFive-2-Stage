import ArgumentParser
import Foundation
import ShellOut

struct sftool: ParsableCommand {
    
    // MARK: - Initializers
    
    init() {}
    
    // MARK: - ParsableCommand
    
    static let configuration = CommandConfiguration(
        abstract: "A command line utility for the ScoreFive iOS repo",
        subcommands: [SwiftFormatCommand.self, GenerateCommand.self]
    )
}

struct GenerateCommand: ParsableCommand {

    // MARK: - Initializers
    
    init() {}
    
    // MARK: - ParsableCommand
    
    static let configuration = CommandConfiguration(
        commandName: "gen",
        abstract: "Generate code",
        subcommands: [GenerateMocks.self, GenerateDependencyGraphCommand.self]
    )
}

sftool.main()
