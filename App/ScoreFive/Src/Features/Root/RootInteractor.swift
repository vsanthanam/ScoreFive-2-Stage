//
//  RootInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
import ShortRibs

/// @mockable
protocol RootPresentable: RootViewControllable {
    var listener: RootPresentableListener? { get set }
    func showMain(_ viewControllable: ViewControllable)
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {
    
    // MARK: - Initializers
    
    init(presenter: RootPresentable,
         mainBuilder: MainBuildable) {
        self.mainBuilder = mainBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - Interactor
    
    override func didBecomeActive() {
        super.didBecomeActive()
        routeToMain()
    }
    
    // MARK: - RootInteractable
    
    var viewController: ViewControllable {
        presenter
    }
    
    // MARK: - Private
    
    private let mainBuilder: MainBuildable
    private var currentMain: PresentableInteractable?
 
    private func routeToMain() {
        if let current = currentMain {
            detach(child: current)
        }
        let interactor = mainBuilder.build(withListener: self)
        attach(child: interactor)
        presenter.showMain(interactor.viewControllable)
        currentMain = interactor
    }
}
