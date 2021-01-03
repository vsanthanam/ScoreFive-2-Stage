//
//  NewRoundBuilder.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ShortRibs
import ScoreKeeping
import NeedleFoundation

protocol NewRoundDependency: Dependency {}

class NewRoundComponent: Component<NewRoundDependency> {}

/// @mockable
protocol NewRoundInteractable: PresentableInteractable {}

typealias NewRoundDynamicBuildDependency = (
    listener: NewRoundListener,
    replacingIndex: Int?,
    previousValue: Round?
)

/// @mockable
protocol NewRoundBuildable: AnyObject {
    func build(withListener listener: NewRoundListener, replacingIndex: Int?, previousValue: Round?) -> PresentableInteractable
}

extension NewRoundBuildable {
    func build(withListener listener: NewRoundListener) -> PresentableInteractable {
        build(withListener: listener, replacingIndex: nil, previousValue: nil)
    }
}

final class NewRoundBuilder: ComponentizedBuilder<NewRoundComponent, PresentableInteractable, NewRoundDynamicBuildDependency, Void>, NewRoundBuildable {
    
    // MARK: - ComponentizedBuilder
    
    override final func build(with component: NewRoundComponent, _ dynamicBuildDependency: NewRoundDynamicBuildDependency) -> PresentableInteractable {
        let (listener, replacingIndex, previousValue) = dynamicBuildDependency
        let viewController = NewRoundViewController()
        let interactor = NewRoundInteractor(presenter: viewController,
                                            replacingIndex: replacingIndex,
                                            previousValue: previousValue)
        interactor.listener = listener
        return interactor
    }
    
    // MARK: - NewRoundBuildable
    
    func build(withListener listener: NewRoundListener, replacingIndex: Int?, previousValue: Round?) -> PresentableInteractable {
        build(withDynamicBuildDependency: (listener, replacingIndex, previousValue),
              dynamicComponentDependency: ())
    }
    
}
