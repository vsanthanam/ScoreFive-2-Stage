//
//  File.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 2/21/21.
//

import Combine
import Foundation

/// @mockable
protocol UserSettings: AnyObject {
    var indexByPlayer: Bool { get set }
    var indexByPlayerStream: AnyPublisher<Bool, Never> { get }
}

final class UserSettingsImpl: UserSettings {

    @UserSetting(key: "index_by_player")
    var indexByPlayer: Bool = true

    var indexByPlayerStream: AnyPublisher<Bool, Never> {
        $indexByPlayer
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

@propertyWrapper
class UserSetting<T> {

    // MARK: - Initializers

    init(wrappedValue value: T, key: String) {
        defaultValue = value
        self.key = key

    }

    // MARK: - PropertyWrapper

    var wrappedValue: T {
        get {
            (UserDefaults.standard.value(forKey: key) as? T) ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
            subject.send(newValue)
        }
    }

    var projectedValue: AnyPublisher<T, Never> {
        subject
            .eraseToAnyPublisher()
    }

    private let key: String
    private let defaultValue: T
    private lazy var subject = CurrentValueSubject<T, Never>(wrappedValue)
}
