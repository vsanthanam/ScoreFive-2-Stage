//
//  PresentableInteractor.swift
//  ShortRibs
//
//  Created by Varun Santhanam on 12/6/20.
//

import Foundation

public protocol PresentableInteractable: Interactable {
    var viewControllable: ViewControllable { get }
}

open class PresentableInteractor<Presenter>: Interactor {
    
    // MARK: - Initializers
    
    /// Create a presentable interactor  for a given presenter
    /// - Parameter presenter: The presenter
    public init(presenter: Presenter) {
        self.presenter = presenter
        super.init()
    }
    
    // MARK: - API
    
    /// The presenter managed by this interactor.
    public let presenter: Presenter

}
