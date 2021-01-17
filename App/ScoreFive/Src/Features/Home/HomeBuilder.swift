//
//  HomeBuilder.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import NeedleFoundation
import ShortRibs

protocol HomeDependency: Dependency {
    var gameStorageManager: GameStorageManaging { get }
}

class HomeComponent: Component<HomeDependency> {

    // MARK: - Children

    fileprivate var newGameBuilder: NewGameBuildable {
        NewGameBuilder { NewGameComponent(parent: self) }
    }

}

/// @mockable
protocol HomeInteractable: FiveStateInteractable, NewGameListener {}

typealias HomeDynamicBuildDependency = (
    HomeListener
)

/// @mockable
protocol HomeBuildable: AnyObject {
    func build(withListener listener: HomeListener) -> FiveStateInteractable
}

final class HomeBuilder: ComponentizedBuilder<HomeComponent, FiveStateInteractable, HomeDynamicBuildDependency, Void>, HomeBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: HomeComponent, _ dynamicBuildDependency: HomeDynamicBuildDependency) -> FiveStateInteractable {
        let listener = dynamicBuildDependency
        let viewController = HomeViewController()
        let interactor = HomeInteractor(presenter: viewController,
                                        gameStorageManager: component.gameStorageManager,
                                        newGameBuilder: component.newGameBuilder)
        interactor.listener = listener
        return interactor
    }

    // MARK: - HomeBuildable

    func build(withListener listener: HomeListener) -> FiveStateInteractable {
        build(withDynamicBuildDependency: listener,
              dynamicComponentDependency: ())
    }

}
