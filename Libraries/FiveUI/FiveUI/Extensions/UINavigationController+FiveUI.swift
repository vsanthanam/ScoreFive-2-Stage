//
//  UINavigationController+FiveUI.swift
//  FiveUI
//
//  Created by Varun Santhanam on 1/18/21.
//

import Foundation
import UIKit

extension UINavigationController {

    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        pushViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            defer {
                completion?()
            }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }

    @discardableResult
    public func popToViewController(_ viewController: UIViewController,
                                    animated: Bool,
                                    completion: (() -> Void)?) -> [UIViewController]? {
        let vcs = popToViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            defer {
                completion?()
            }
            return vcs
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
        return vcs
    }

    public func popViewController(animated: Bool, completion: (() -> Void)?) {
        popViewController(animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            defer {
                completion?()
            }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }

}
