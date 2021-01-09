import ArgumentParser
import Foundation
import ShellOut

struct sfcli: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A command line utility for the ScoreFive iOS repo",
        subcommands: [Format.self]
    )

    init() {}
}

struct Format: ParsableCommand {

    public static let configuration = CommandConfiguration(abstract: "Run swiftformat on the appropriate files")

    @Flag(name: .long, help: "Display verbose logging")
    private var verbose: Bool = false

    enum FormatError: Error {
        case config
        case prepare
        case process(_ description: String)
        case cleanup

        var localizedDescription: String {
            switch self {
            case .config:
                return "Missing swiftformat file!"
            case .prepare:
                return "Couldn't generate .swiftformat file!"
            case let .process(description):
                return "Formatting failed: \(description)"
            case .cleanup:
                return "Cleanup failed!"
            }
        }
    }

    func run() throws {
        print("Preparing...")
        do {
            try shellOut(to: .copyFile(from: "scorefive-swiftformat", to: ".swiftformat"))
            print("Configuration located")
        } catch {
            print("Formatting failed!")
            throw FormatError.prepare
        }

        if verbose {
            do {
                let file = try shellOut(to: .readFile(at: ".swiftformat"))
                print("Configuration Contents:")
                print(file)
            } catch {
                print("Configuration Unreadable")
            }
        }

        do {
            print("Formatting files...")
            try shellOut(to: "swiftformat .")
        } catch {
            print("Formatting failed!")
            let error = error as! ShellOutError
            throw FormatError.process(error.message)
        }

        do {
            print("Cleaning up...")
            try shellOut(to: .removeFile(from: ".swiftformat"))
            print("Formatting complete! 🍻")
        } catch {
            print("Cleanup failed!")
            throw FormatError.cleanup
        }
    }
}

sfcli.main()
