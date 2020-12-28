//
//  FiveViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/28/20.
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol FiveViewControllable: ViewControllable {}

/// @mockable
protocol FivePresentableListener: AnyObject {}

final class FiveViewController: ScopeViewController, FivePresentable, FiveViewControllable {
    
    // MARK: - FivePresentable
    
    weak var listener: FivePresentableListener?
}
