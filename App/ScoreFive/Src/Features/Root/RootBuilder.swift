//
//  RootBuilder.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
import ShortRibs
import NeedleFoundation
import UIKit

typealias RootDynamicComponentDependency = (
    PersistentContaining
)

final class RootComponent: BootstrapComponent {
    
    // MARK: - Initializers
    
    init(dynamicDependency: RootDynamicComponentDependency) {
        self.dynamicDependency = dynamicDependency
    }
    
    // MARK: - Published Dependencies
    
    var persistentContainer: PersistentContaining {
        dynamicDependency
    }
    
    // MARK: - Children
    
    fileprivate var mainBuilder: MainBuildable {
        MainBuilder { MainComponent(parent: self) }
    }
    
    // MARK: - Private
    
    private let dynamicDependency: RootDynamicComponentDependency
}

/// @mockable
protocol RootInteractable: PresentableInteractable, MainListener {}

typealias RootDynamicBuildDependency = (
    UIWindow
)

/// @mockable
protocol RootBuildable: AnyObject {
    func build(onWindow window: UIWindow, persistentContainer: PersistentContaining) -> PresentableInteractable
}

final class RootBuilder: ComponentizedBuilder<RootComponent, PresentableInteractable, RootDynamicBuildDependency, RootDynamicComponentDependency>, RootBuildable {
    
    // MARK: - Initializers
    
    init() {
        super.init { dynamicDepenency in
            .init(dynamicDependency: dynamicDepenency)
        }
    }
    
    @available(*, unavailable)
    required init(componentBuilder: @escaping RootBuilder.ComponentBuilder) {
        fatalError()
    }
    
    // MARK: - ComponentizedBuilder
    
    override final func build(with component: RootComponent, _ dynamicBuildDependency: RootDynamicBuildDependency) -> PresentableInteractable {
        let window = dynamicBuildDependency
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController,
                                        mainBuilder: component.mainBuilder)
        window.rootViewController = viewController
        return interactor
    }
    
    // MARK: - RootBuildable
    
    func build(onWindow window: UIWindow, persistentContainer: PersistentContaining) -> PresentableInteractable {
        build(withDynamicBuildDependency: window,
              dynamicComponentDependency: persistentContainer)
    }
    
}
