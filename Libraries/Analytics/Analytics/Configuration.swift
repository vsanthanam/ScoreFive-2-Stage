//
//  Configuration.swift
//  Analytics
//
//  Created by Varun Santhanam on 1/31/21.
//

import Foundation
import Countly

public struct AnalyticsConfig: Codable {
    
    public struct Settings: Codable {
        let appKey: String
        let host: String
    }
    
    public let settings: Settings?
}


public func startAnalytics(with config: AnalyticsConfig) {
    guard let settings = config.settings else {
        return
    }
    let countlyConfig = CountlyConfig()
    countlyConfig.appKey = settings.appKey
    countlyConfig.host = settings.host
    countlyConfig.features = [.crashReporting]
    Countly.sharedInstance().start(with: countlyConfig)
}
