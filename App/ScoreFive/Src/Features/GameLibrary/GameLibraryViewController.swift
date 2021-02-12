//
//  GameLibraryViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 2/10/21.
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol GameLibraryViewControllable: ViewControllable {}

/// @mockable
protocol GameLibraryPresentableListener: AnyObject {
    func didTapClose()
}

final class GameLibraryViewController: ScopeViewController, GameLibraryPresentable, GameLibraryViewControllable {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        view.backgroundColor = .backgroundPrimary
    }

    // MARK: - GameLibraryPresentable

    weak var listener: GameLibraryPresentableListener?
}
