//
//  File.swift
//
//
//  Created by Varun Santhanam on 1/9/21.
//

import Foundation
import ShellOut

enum FormatError: Error {
    case prepare(_ description: String)
    case process(_ description: String)
    case cleanup(_ description: String)

    var localizedDescription: String {
        switch self {
        case .prepare:
            return "Couldn't generate .swiftformat file!"
        case let .process(description):
            return "Formatting failed: \(description)"
        case .cleanup:
            return "Cleanup failed!"
        }
    }
}

func swiftFormat(verbose: Bool = false, root: String) throws {
    print("Preparing...")
    do {
        try shellOut(to: .copyFile(from: root + "/scorefive-swiftformat", to: root + "/.swiftformat"))
        print("Configuration located")
    } catch {
        let error = error as! ShellOutError
        throw FormatError.prepare(error.message)
    }

    if verbose {
        do {
            let file = try shellOut(to: .readFile(at: root + "/.swiftformat"))
            print("Configuration Contents:")
            print(file)
        } catch {
            print("Configuration Unreadable")
        }
    }

    do {
        print("Formatting files...")
        try shellOut(to: "swiftformat " + root)
        print("Files formatted")
    } catch {
        let error = error as! ShellOutError
        throw FormatError.process(error.message)
    }

    do {
        print("Cleaning up...")
        try shellOut(to: .removeFile(from: root + "/.swiftformat"))
    } catch {
        let error = error as! ShellOutError
        throw FormatError.cleanup(error.message)
    }
}
