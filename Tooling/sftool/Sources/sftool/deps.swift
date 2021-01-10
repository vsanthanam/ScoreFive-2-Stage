//
//  File.swift
//
//
//  Created by Varun Santhanam on 1/9/21.
//

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

func runNeedle(root: String) throws {
    do {
        let inputDir = root + "/App/ScoreFive/src/Features/"
        let outputDir = root + "/App/ScoreFive/Src/Infra/DependencyGraph.swift"
        try shellOut(to: "export SOURCEKIT_LOGGING=0 && needle generate \(outputDir) \(inputDir)")
        print("DI Graph Generated!")
    } catch {
        let error = error as! ShellOutError
        throw DepsError.needle(error)
    }
}
