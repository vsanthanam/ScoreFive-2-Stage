//
//  ScoreCardViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/30/20.
//

import Foundation
import ScoreKeeping
import ShortRibs
import UIKit

/// @mockable
protocol ScoreCardViewControllable: ViewControllable {}

/// @mockable
protocol ScoreCardPresentableListener: AnyObject {}

final class ScoreCardViewController: BaseScopeViewController<ScoreCardView>, ScoreCardPresentable, ScoreCardViewControllable, ScoreCardViewDelegate {
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        specializedView.delegate = self
    }
    
    // MARK: - ScoreCardPresentable
    
    weak var listener: ScoreCardPresentableListener?
    
    func update(scoreCard: ScoreCard) {
        self.scoreCard = scoreCard
        specializedView.reload()
    }
    
    // MARK: - Private
    
    private var scoreCard: ScoreCard?
}
