//
//  ScoreLimitCell.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/30/20.
//

import FiveUI
import Foundation
import UIKit

protocol ScoreLimitCellDelegate: AnyObject {
    func didInputScoreLimit(input: String?)
}

final class ScoreLimitCell: ListCellView<ScoreLimitCell.ContentConfiguration, ScoreLimitCell.ContentView> {
    
    final class ContentView: CellContentView<ContentConfiguration> {
        
        // MARK: - Initializers
        
        override init(configuration: ContentConfiguration) {
            super.init(configuration: configuration)
            setUp()
        }
        
        // MARK: - CellContentView
        
        override func apply(configuration: ContentConfiguration) {
            input.placeholder = configuration.defaultScore
            input.text = configuration.enteredScore
            editingAction = UIAction { [unowned input] _ in
                self.specializedConfiguration.delegate?.didInputScoreLimit(input: input.text)
            }
        }
        
        // MARK: - Private
        
        private let input = UITextField()
        
        private var editingAction: UIAction? {
            didSet {
                if let oldAction = oldValue {
                    input.removeAction(oldAction, for: .editingChanged)
                }
                if let newAction = editingAction {
                    input.addAction(newAction, for: .editingChanged)
                }
            }
        }
        
        private func setUp() {
            input.textAlignment = .center
            input.font = .preferredFont(forTextStyle: .largeTitle)
            input.keyboardType = .numberPad
            addSubview(input)
            input.snp.makeConstraints { make in
                make
                    .edges
                    .equalToSuperview()
                    .inset(8.0)
            }
        }
    }
    
    struct ContentConfiguration: CellContentConfiguration {
        
        // MARK: - API
        
        var defaultScore: String?
        var enteredScore: String?
        
        weak var delegate: ScoreLimitCellDelegate?
        
        // MARK: - UIContentConfiguration
        
        func makeContentView() -> UIView & UIContentView {
            ContentView(configuration: self)
        }
        
        func updated(for state: UIConfigurationState) -> ContentConfiguration {
            self
        }
    }
}
