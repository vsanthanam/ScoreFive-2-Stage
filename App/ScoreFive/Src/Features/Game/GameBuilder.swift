//
//  GameBuilder.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ShortRibs
import NeedleFoundation

protocol GameDependency: Dependency {
    var gameStorageManager: GameStorageManaging { get }
    var activeGameStream: ActiveGameStreaming { get }
}

class GameComponent: Component<GameDependency> {
    
    // MARK: - Children
    
    fileprivate var newRoundBuilder: NewRoundBuildable {
        NewRoundBuilder { NewRoundComponent(parent: self) }
    }
    
    fileprivate var scoreCardBuilder: ScoreCardBuildable {
        ScoreCardBuilder { ScoreCardComponent(parent: self) }
    }
    
}

/// @mockable
protocol GameInteractable: PresentableInteractable, NewRoundListener, ScoreCardListener {}

typealias GameDynamicBuildDependency = (
    GameListener
)

/// @mockable
protocol GameBuildable: AnyObject {
    func build(withListener listener: GameListener) -> PresentableInteractable
}

final class GameBuilder: ComponentizedBuilder<GameComponent, PresentableInteractable, GameDynamicBuildDependency, Void>, GameBuildable {
    
    // MARK: - ComponentizedBuilder
    
    override final func build(with component: GameComponent, _ dynamicBuildDependency: GameDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = GameViewController()
        let interactor = GameInteractor(presenter: viewController,
                                        gameStorageManager: component.gameStorageManager,
                                        activeGameStream: component.activeGameStream,
                                        newRoundBuilder: component.newRoundBuilder,
                                        scoreCardBuilder: component.scoreCardBuilder)
        viewController.listener = interactor
        interactor.listener = listener
        return interactor
    }
    
    // MARK: - GameBuildable
    
    func build(withListener listener: GameListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener,
              dynamicComponentDependency: ())
    }
    
}
