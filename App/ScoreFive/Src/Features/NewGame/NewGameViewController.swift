//
//  NewGameViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import ScoreKeeping
import FiveUI
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol NewGameViewControllable: ViewControllable {}

/// @mockable
protocol NewGamePresentableListener: AnyObject {
    func didTapNewGame(with playerNames: [String?], scoreLimit: Int)
}

final class NewGameViewController: ScopeViewController, NewGamePresentable, NewGameViewControllable {
    
    // MARK: - Initializers
    
    override init(_ viewBuilder: @escaping () -> ScopeView) {
        super.init(viewBuilder)
        isModalInPresentation = true
        modalPresentationStyle = .fullScreen
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - NewGamePresentable
    
    weak var listener: NewGamePresentableListener?
    
    // MARK: - Private
    
    private func setUp() {
        specializedView.backgroundColor = .backgroundPrimary
        let textField = TextField()
        textField.font = .systemFont(ofSize: 24.0)
        textField.placeholder = "Score Limit"
        textField.textAlignment = .center
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make
                .top
                .leading
                .trailing
                .equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }

}
