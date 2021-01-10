//
//  Mocks.swift
//
//
//  Created by Varun Santhanam on 1/9/21.
//

import Foundation
import ShellOut

enum MocksError: Error {
    case mockolo(_ description: String)

    var localizedDescrpition: String {
        switch self {
        case let .mockolo(description):
            return "Mockolo Failed: \(description)"
        }
    }
}

func runMockolo(root: String) throws {
    do {
        let appInput =  root + "/App/ScoreFive/Src"
        let libsInput = root + "/Libraries"
        let mocksOutput = root + "/App/ScoreFiveTests/Mocks.swift"
        try shellOut(to: "mockolo -s \(appInput) \(libsInput) -d \(mocksOutput) -i ShortRibs ScoreFive")
        print("Mocks Generated!")
    } catch {
        let error = error as! ShellOutError
        throw MocksError.mockolo(error.message)
    }
}
