//
//  Builder.swift
//  ShortRibs
//
//  Created by Varun Santhanam on 12/27/20.
//

import Foundation

/// @CreateMock
public protocol Buildable: AnyObject {}

open class Builder<Dependency>: Buildable {

    public init(dependency: Dependency) {
        self.dependency = dependency
    }

    public let dependency: Dependency

}
