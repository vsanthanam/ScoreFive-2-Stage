//
//  NewGameBuilder.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ShortRibs
import NeedleFoundation

protocol NewGameDependency: Dependency {}

class NewGameComponent: Component<NewGameDependency> {}

/// @mockable
protocol NewGameInteractable: PresentableInteractable {}

typealias NewGameDynamicBuildDependency = (
    NewGameListener
)

/// @mockable
protocol NewGameBuildable: AnyObject {
    func build(withListener listener: NewGameListener) -> PresentableInteractable
}

final class NewGameBuilder: ComponentizedBuilder<NewGameComponent, PresentableInteractable, NewGameDynamicBuildDependency, Void>, NewGameBuildable {
    
    // MARK: - ComponentizedBuilder
    
    override final func build(with component: NewGameComponent, _ dynamicBuildDependency: NewGameDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = NewGameViewController()
        let interactor = NewGameInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }
    
    // MARK: - NewGameBuildable
    
    func build(withListener listener: NewGameListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener,
              dynamicComponentDependency: ())
    }
    
}
