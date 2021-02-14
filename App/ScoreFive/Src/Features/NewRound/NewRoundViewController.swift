//
//  NewRoundViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import FiveUI
import Foundation
import ShortRibs
import SnapKit
import UIKit

/// @mockable
protocol NewRoundViewControllable: ViewControllable {}

/// @mockable
protocol NewRoundPresentableListener: AnyObject {
    func didTapClose()
    func didSaveScore(_ score: Int)
}

final class NewRoundViewController: ScopeViewController, NewRoundPresentable, NewRoundViewControllable, UINavigationBarDelegate, RoundScoreViewDelegate {
    
    // MARK: - Initializers
    
    init(replacing: Bool) {
        self.replacing = replacing
        super.init(ScopeView.init)
        isModalInPresentation = true
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        startObservingKeyboardNotifications()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entryView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        entryView.resignFirstResponder()
    }

    // MARK: - NewRoundPresentable

    weak var listener: NewRoundPresentableListener?
    
    func advanceToNextPlayer() {
        entryView.advance()
    }
    
    // MARK: - UINavigationBarDelegate

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }

    // MARK: - RoundScoreViewDelegate
    
    func scoreValueChanged(_ input: String) {
        guard input != "" else {
            return
        }
        
        guard let value = Int(input) else {
            entryView.shake(newValue: "")
            return
        }
        
        guard value <= 50 else {
            entryView.shake(newValue: "")
            return
        }
    }
    
    func scoreDidAccept() {
        guard entryView.visibleScore != "" else {
            return
        }
        
        guard let value = Int(entryView.visibleScore) else {
            entryView.shake(newValue: "")
            return
        }
        
        guard value <= 50 else {
            entryView.shake(newValue: "")
            return
        }
        
        listener?.didSaveScore(value)
    }
    
    // MARK: - Private

    private let replacing: Bool
    private let header = UINavigationBar()
    private let entryView = RoundScoreView()
    private let keyboardLayoutGuide = UILayoutGuide()

    private var keyboardConstraint: Constraint?
    
    private func setUp() {
        specializedView.addLayoutGuide(keyboardLayoutGuide)
        specializedView.backgroundColor = .backgroundPrimary

        let navigationItem = UINavigationItem(title: replacing ? "Edit Scores" : "Add Scores")
        navigationItem.largeTitleDisplayMode = .always

        let closeItem = UIBarButtonItem(barButtonSystemItem: .close,
                                        target: self,
                                        action: #selector(close))
        navigationItem.leftBarButtonItem = closeItem

        header.setItems([navigationItem], animated: false)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundPrimary

        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 10 // This is added to the default margin
        appearance.largeTitleTextAttributes = [.paragraphStyle: style]

        header.scrollEdgeAppearance = appearance
        header.delegate = self
        header.prefersLargeTitles = true
        specializedView.addSubview(header)

        header.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .equalToSuperview()
            make
                .top
                .equalTo(specializedView.safeAreaLayoutGuide)
        }

        keyboardLayoutGuide.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .equalToSuperview()
            make
                .top
                .equalTo(header.snp.bottom)
            keyboardConstraint = make
                .bottom
                .equalToSuperview()
                .constraint
        }
        
        specializedView.addSubview(entryView)
        entryView.snp.makeConstraints { make in
            make
                .edges
                .equalTo(keyboardLayoutGuide)
        }
        entryView.delegate = self
    }

    @objc
    private func close() {
        listener?.didTapClose()
    }
    
    private func startObservingKeyboardNotifications() {
        UIResponder.keyboardWillHideNotification
            .asPublisher()
            .sink { notif in
                self.handleKeyboardNotification(notif)
            }
            .cancelOnDeinit(self)
        UIResponder.keyboardWillChangeFrameNotification
            .asPublisher()
            .sink { notif in
                self.handleKeyboardNotification(notif)
            }
            .cancelOnDeinit(self)
    }

    private func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            keyboardConstraint?.update(inset: 0.0)
        } else {
            keyboardConstraint?.update(inset: keyboardViewEndFrame.height - view.safeAreaInsets.bottom)
        }
    }
}
