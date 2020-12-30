//
//  NewRoundViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol NewRoundViewControllable: ViewControllable {}

/// @mockable
protocol NewRoundPresentableListener: AnyObject {}

final class NewRoundViewController: ScopeViewController, NewRoundPresentable, NewRoundViewControllable {
    
    // MARK: - NewRoundPresentable
    
    weak var listener: NewRoundPresentableListener?
}
