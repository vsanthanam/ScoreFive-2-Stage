//
//  GameLibraryBuilder.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 2/10/21.
//

import Foundation
import NeedleFoundation
import ShortRibs

protocol GameLibraryDependency: Dependency {}

class GameLibraryComponent: Component<GameLibraryDependency> {}

/// @mockable
protocol GameLibraryInteractable: PresentableInteractable {}

typealias GameLibraryDynamicBuildDependency = (
    GameLibraryListener
)

/// @mockable
protocol GameLibraryBuildable: AnyObject {
    func build(withListener listener: GameLibraryListener) -> PresentableInteractable
}

final class GameLibraryBuilder: ComponentizedBuilder<GameLibraryComponent, PresentableInteractable, GameLibraryDynamicBuildDependency, Void>, GameLibraryBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: GameLibraryComponent, _ dynamicBuildDependency: GameLibraryDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = GameLibraryViewController()
        let interactor = GameLibraryInteractor(presenter: viewController)
        viewController.listener = interactor
        interactor.listener = listener
        return interactor
    }

    // MARK: - GameLibraryBuildable

    func build(withListener listener: GameLibraryListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener,
              dynamicComponentDependency: ())
    }

}
