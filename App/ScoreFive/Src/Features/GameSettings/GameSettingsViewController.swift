//
//  GameSettingsViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 2/10/21.
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol GameSettingsViewControllable: ViewControllable {}

/// @mockable
protocol GameSettingsPresentableListener: AnyObject {}

final class GameSettingsViewController: ScopeViewController, GameSettingsPresentable, GameSettingsViewControllable {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundPrimary
        isModalInPresentation = true
    }

    // MARK: - GameSettingsPresentable

    weak var listener: GameSettingsPresentableListener?
}
