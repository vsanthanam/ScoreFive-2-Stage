//
//  NewGameButton.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 1/1/21.
//

import FiveUI
import Foundation
import UIKit

final class NewGameButton: TappableControl {
    
    override init() {
        super.init()
        setUp()
    }
    
    // MARK: - UIControl
    
    override var isHighlighted: Bool {
        didSet {
            updateColors()
        }
    }
    
    // MARK: - Private
    
    private let label = UILabel()
    
    private func setUp() {
        label.text = "Start Game"
        label.textColor = .contentOnColorPrimary
        addSubview(label)
        label.snp.makeConstraints { make in
            make
                .center
                .equalToSuperview()
            make
                .top
                .bottom
                .equalToSuperview()
                .inset(12.0)
        }
        updateColors()
    }
    
    private func updateColors() {
        if isHighlighted {
            backgroundColor = .contentAccentSecondary
        } else {
            backgroundColor = .contentAccentPrimary
        }
    }
    
}
