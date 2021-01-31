//
//  File.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 1/30/21.
//

import Combine
import Foundation

extension Notification.Name {

    func asPublisher() -> AnyPublisher<Notification, Never> {
        NotificationCenter.default.publisher(for: self, object: nil).eraseToAnyPublisher()
    }

}
