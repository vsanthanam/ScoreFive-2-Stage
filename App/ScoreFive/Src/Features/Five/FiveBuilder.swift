//
//  FiveBuilder.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
import ShortRibs
import NeedleFoundation

protocol FiveDependency: Dependency {
    var persistentContainer: PersistentContaining { get }
}

class FiveComponent: Component<FiveDependency> {
    
    // MARK: - Published Dependencies
    
    var gameStorageProvider: GameStorageProviding {
        gameStorageWorker
    }
    
    var gameStorageManager: GameStorageManaging {
        gameStorageWorker
    }
    
    // MARK: - Internal Dependencies
    
    fileprivate var gameStorageWorker: GameStorageWorking {
        shared { GameStorageWorker(persistentContainer: dependency.persistentContainer) }
    }
}

/// @mockable
protocol FiveInteractable: PresentableInteractable {}

typealias FiveDynamicBuildDependency = (
    FiveListener
)

/// @mockable
protocol FiveBuildable: AnyObject {
    func build(withListener listener: FiveListener) -> PresentableInteractable
}

final class FiveBuilder: ComponentizedBuilder<FiveComponent, PresentableInteractable, FiveDynamicBuildDependency, Void>, FiveBuildable {
    
    // MARK: - ComponentizedBuilder
    
    override final func build(with component: FiveComponent, _ dynamicBuildDependency: FiveDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = FiveViewController()
        let interactor = FiveInteractor(presenter: viewController,
                                        gameStorageWorker: component.gameStorageWorker)
        interactor.listener = listener
        return interactor
    }
    
    // MARK: - FiveBuildable
    
    func build(withListener listener: FiveListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener,
              dynamicComponentDependency: ())
    }
    
}
