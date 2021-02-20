//
//  File.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 1/30/21.
//

import Combine
import Foundation

extension Notification.Name {

    func asPublisher<T>(object: T?) -> AnyPublisher<Notification, Never> where T: AnyObject {
        NotificationCenter.default.publisher(for: self, object: object).eraseToAnyPublisher()
    }

    func asPublisher(_ object: AnyObject? = nil) -> AnyPublisher<Notification, Never> {
        asPublisher(object: object)
    }

}
