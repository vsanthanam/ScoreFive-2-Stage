//
//  NewGameCell.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/30/20.
//

import FiveUI
import Foundation
import UIKit

protocol NewPlayerCellDelegate: AnyObject {
    func didInputPlayerName(input: String?, index: Int)
}

final class NewPlayerCell: ListCellView<NewPlayerCell.ContentConfiguration, NewPlayerCell.ContentView> {

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
            input.textColor = .contentPrimary
            input.backgroundColor = .transparent
            input.clearButtonMode = .whileEditing
            input.returnKeyType = .done
            input.addAction(UIAction { [unowned input] _ in
                input.resignFirstResponder()
            }, for: .editingDidEndOnExit)
            backgroundColor = .transparent
            addSubview(input)
            input.snp.makeConstraints { make in
                make
                    .top
                    .bottom
                    .equalToSuperview()
                    .inset(8.0)
                make
                    .leading
                    .trailing
                    .equalToSuperview()
                    .inset(16.0)
                make
                    .height
                    .greaterThanOrEqualTo(28.0)
            }
        }
    }

    struct ContentConfiguration: CellContentConfiguration {
        
        // MARK: - API
        
        weak var delegate: NewPlayerCellDelegate?
        
        var playerIndex = 0
        var enteredPlayerName: String?
        
        // MARK: - UIContentConfiguration
        
        func makeContentView() -> UIView & UIContentView { ContentView(configuration: self) }
        
        func updated(for state: UIConfigurationState) -> ContentConfiguration { self }
    }
}
