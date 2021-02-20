import ArgumentParser
import Foundation
import ShellOut

struct sftool: ParsableCommand {

    // MARK: - Initializers

    init() {}

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(
        abstract: "A command line utility for the ScoreFive iOS repo",
        subcommands: [SwiftFormatCommand.self,
                      GenerateCommand.self,
                      SwiftLintCommand.self,
                      BootstrapCommand.self,
                      AnalyticsCommand.self,
                      TestCommand.self]
    )
}

enum Commands {
    static func generateDependencyGraph(_ root: String, diCodePath: String, diGraphPath: String, verbose: Bool) throws {
        let needleInput = root + "/" + diCodePath
        let dependencyGraph = root + "/" + diGraphPath
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

    static func generateMocks(_ root: String, featureCodePath: String, libraryCodePath: String, mockPath: String, testableImports: [String], verbose: Bool) throws {
        let featureCode = root + "/" + featureCodePath
        let libraryCode = root + "/" + libraryCodePath
        let mocks = root + "/" + mockPath
        if verbose {
            print("Input Paths:")
            print(featureCode)
            print(libraryCode)
            print("Output Path:")
            print(mocks)
        }
        var command = "mockolo -s \(featureCode) \(libraryCode) -d \(mocks)"
        if !testableImports.isEmpty {
            if verbose {
                print("Adding Testable Imports")
                testableImports.forEach { print($0) }
            }
            command.append(" ")
            command.append((["-i"] + testableImports).joined(separator: " "))
        }
        if verbose {
            print("Running command \(command)")
        }
        try shellOut(to: command)
    }

    static func writeAnalyticsConfiguration(_ root: String, config: AnalyticsConfig = .empty) throws {
        let data = try JSONEncoder().encode(config)
        let targetPath = "/App/ScoreFive/Resources/analytics_config.json"
        try shellOut(to: .removeFile(from: root + targetPath))
        try NSData(data: data).write(toFile: root + targetPath)
    }

    static func readAnalyticsConfiguration(_ root: String) throws -> AnalyticsConfig {
        func readFile() throws -> String {
            do {
                return try shellOut(to: .readFile(at: root + "/App/ScoreFive/Resources/analytics_config.json"))
            } catch {
                throw ConfigurationError.notFound(error: error as! ShellOutError)
            }
        }

        let file = try readFile()

        let jsonData = file.data(using: .utf8)!
        let decoder = JSONDecoder()
        return try decoder.decode(AnalyticsConfig.self, from: jsonData)
    }

    static func runTests(_ root: String, name: String, os: String) throws -> String {
        try shellOut(to: "xcodebuild -workspace \(root)/ScoreFive.xcworkspace -sdk iphonesimulator -scheme ScoreFive -destination 'platform=iOS Simulator,name=\(name),OS=\(os)' test")
    }
}

sftool.main()
