//
//  MoreViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 2/10/21.
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol MoreOptionsViewControllable: ViewControllable {}

/// @mockable
protocol MoreOptionsPresentableListener: AnyObject {}

final class MoreOptionsViewController: ScopeViewController, MoreOptionsPresentable, MoreOptionsViewControllable {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        view.backgroundColor = .backgroundPrimary
    }

    // MARK: - MorePresentable

    weak var listener: MoreOptionsPresentableListener?
}
