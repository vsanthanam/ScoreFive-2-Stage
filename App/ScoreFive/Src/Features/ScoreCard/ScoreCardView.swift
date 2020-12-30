//
//  ScoreCardView.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/30/20.
//

import FiveUI
import Foundation
import ShortRibs
import ScoreKeeping
import UIKit

protocol ScoreCardViewDelegate: AnyObject {
    
}

final class ScoreCardView: ScopeView {
    
    override init() {
        super.init()
        setUp()
    }
    
    weak var delegate: ScoreCardViewDelegate?
    
    func reload() {
        
    }
    
    private func setUp() {
        backgroundColor = .backgroundPrimary
    }
    
}
