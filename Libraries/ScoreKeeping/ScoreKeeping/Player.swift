//
//  Player.swift
//  ScoreKeeping
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation

/// A player is a struct that uniquely identifies each player in a game while also providing a human-readable name
public struct Player: Codable, Hashable, Equatable {

    /// Create a player
    /// - Parameters:
    ///   - name: The human-readalbe name of the player
    ///   - uuid: The unique identifier of the player
    public init(name: String,
                uuid: UUID = .init()) {
        self.name = name
        self.uuid = uuid
    }

    /// The unique identifier of the player
    public let uuid: UUID

    /// The name of the player
    public let name: String
}

public func == (lhs: Player, rhs: Player) -> Bool {
    lhs.uuid == rhs.uuid
}
