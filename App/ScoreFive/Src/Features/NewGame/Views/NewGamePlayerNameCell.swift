//
//  AddPlayerCell.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 1/1/21.
//

import FiveUI
import Foundation
import UIKit

protocol NewGamePlayerNameCellDelegate: AnyObject {
    func didInputPlayerName(input: String?, index: Int)
}

final class NewGamePlayerNameCell: ListCell<NewGamePlayerNameCell.ContentConfiguration, NewGamePlayerNameCell.ContentView> {

    final class ContentView: CellContentView<ContentConfiguration> {
        
        // MARK: - Initializrs
        
        override init(configuration: ContentConfiguration) {
            super.init(configuration: configuration)
            setUp()
        }
        
        // MARK: - CellContentView
        
        override func apply(configuration: ContentConfiguration) {
            input.placeholder = "Player \(configuration.playerIndex + 1)"
            input.text = configuration.enteredPlayerName
            editingAction = UIAction { [unowned input] _ in
                configuration.delegate?.didInputPlayerName(input: input.text, index: configuration.playerIndex)
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
            input.clearButtonMode = .whileEditing
            input.returnKeyType = .done
            input.addAction(UIAction { [unowned input] _ in
                input.resignFirstResponder()
            }, for: .editingDidEndOnExit)
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
                    .inset(8.0)
            }
        }
    }

    struct ContentConfiguration: CellContentConfiguration {
        
        // MARK: - API
        
        weak var delegate: NewGamePlayerNameCellDelegate?
        
        var playerIndex = 0
        var enteredPlayerName: String?
        
        // MARK: - UIContentConfiguration
        
        func makeContentView() -> UIView & UIContentView { ContentView(configuration: self) }
        
        func updated(for state: UIConfigurationState) -> ContentConfiguration { self }
    }
}

