//
//  ScoreLimitCell.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/30/20.
//

import FiveUI
import Foundation
import UIKit

protocol NewGameScoreLimitCellDelegate: AnyObject {
    func didInputScoreLimit(input: String?)
}

final class NewGameScoreLimitCell: ListCell<NewGameScoreLimitCell.ContentConfiguration, NewGameScoreLimitCell.ContentView> {
    
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
        
        private let input = TextField()
        
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
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 32).isActive = true // 30 is my added up left and right Inset
            topAnchor.constraint(equalTo: topAnchor).isActive = true
            leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            input.font = .systemFont(ofSize: 36.0)
            input.keyboardType = .numberPad
            addSubview(input)
            input.snp.makeConstraints { make in
                make
                    .leading
                    .trailing
                    .equalToSuperview()
                make
                    .top
                    .bottom
                    .equalToSuperview()
                    .inset(16.0)
            }
        }
    }
    
    struct ContentConfiguration: CellContentConfiguration {
        
        // MARK: - API
        
        var defaultScore: String?
        var enteredScore: String?
        
        weak var delegate: NewGameScoreLimitCellDelegate?
        
        // MARK: - UIContentConfiguration
        
        func makeContentView() -> UIView & UIContentView {
            ContentView(configuration: self)
        }
        
        func updated(for state: UIConfigurationState) -> ContentConfiguration {
            self
        }
    }
}
