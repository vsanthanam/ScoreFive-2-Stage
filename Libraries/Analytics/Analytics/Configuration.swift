//
//  Configuration.swift
//  Analytics
//
//  Created by Varun Santhanam on 1/31/21.
//

import Countly
import Foundation

public struct AnalyticsConfig: Codable {
    let appKey: String?
    let host: String?
}

public func startAnalytics(with config: AnalyticsConfig) {
    guard let appKey = config.appKey,
        let host = config.host else {
        return
    }
    let countlyConfig = CountlyConfig()
    countlyConfig.appKey = appKey
    countlyConfig.host = host
    countlyConfig.features = [.crashReporting]
    Countly.sharedInstance().start(with: countlyConfig)
}
