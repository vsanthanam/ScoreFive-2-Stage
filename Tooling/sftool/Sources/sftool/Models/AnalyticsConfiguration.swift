//
//  File.swift
//
//
//  Created by Varun Santhanam on 1/31/21.
//

public struct AnalyticsConfig: Codable {
    let appKey: String?
    let host: String?

    static var empty: AnalyticsConfig {
        .init(appKey: nil, host: nil)
    }
}
