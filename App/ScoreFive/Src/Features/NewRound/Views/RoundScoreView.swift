//
//  RoundScoreView.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 2/13/21.
//

import FiveUI
import Foundation
import SnapKit
import UIKit

protocol RoundScoreViewDelegate: AnyObject {
    func scoreValueChanged(_ input: String)
    func scoreDidAccept()
}

final class RoundScoreView: BaseView {

    override init() {
        super.init()
        setUp()
    }

    weak var delegate: RoundScoreViewDelegate?

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        input?.becomeFirstResponder() ?? super.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        input?.resignFirstResponder() ?? super.resignFirstResponder()
    }

    var visibleScore: String {
        get {
            input?.text ?? ""
        }
        set {
            input?.text = newValue
        }
    }

    var visibleTitle: String {
        get {
            titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    func shake(newValue: String? = nil) {
        let feedback = UINotificationFeedbackGenerator()
        feedback.prepare()
        input?.shake()
        feedback.notificationOccurred(.error)
        visibleScore = newValue ?? ""
    }

    func advance(newValue: String?) {
        let feedback = UINotificationFeedbackGenerator()
        feedback.prepare()
        let newInput = ScoreInput()
        configureInput(newInput)
        newInput.text = newValue

        guard let oldInput = input else {
            return
        }

        newInput.frame = oldInput.frame.offsetBy(dx: oldInput.bounds.size.width, dy: 0.0)

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .layoutSubviews, animations: {
            newInput.frame = oldInput.frame
            oldInput.transform = CGAffineTransform(translationX: -oldInput.bounds.size.width, y: 0.0)
            newInput.becomeFirstResponder()
            feedback.notificationOccurred(.success)
        }, completion: { [weak self] _ in
            oldInput.removeFromSuperview()
            self?.input = newInput
            self?.constrainInput()
        })
    }

    func regress(newValue: String?) {
        let feedback = UINotificationFeedbackGenerator()
        feedback.prepare()
        let newInput = ScoreInput()
        configureInput(newInput)
        newInput.text = newValue

        guard let oldInput = input else {
            return
        }

        newInput.frame = oldInput.frame.offsetBy(dx: -oldInput.bounds.size.width, dy: 0.0)

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .layoutSubviews, animations: {
            newInput.frame = oldInput.frame
            oldInput.transform = CGAffineTransform(translationX: oldInput.bounds.size.width, y: 0.0)
            newInput.becomeFirstResponder()
            feedback.notificationOccurred(.success)
        }, completion: { [weak self] _ in
            oldInput.removeFromSuperview()
            self?.input = newInput
            self?.constrainInput()
        })
    }

    // MARK: - Private

    private var input: ScoreInput?
    private let titleLabel = UILabel()

    private func setUp() {
        backgroundColor = .backgroundPrimary

        titleLabel.font = .systemFont(ofSize: 17.0, weight: .semibold)
        titleLabel.textColor = .contentSecondary

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make
                .centerX
                .equalToSuperview()
            make
                .top
                .equalToSuperview()
        }

        let input = ScoreInput()
        configureInput(input)
        self.input = input
        constrainInput()
    }

    @objc
    private func userDidAccept() {
        delegate?.scoreDidAccept()
    }

    @objc
    private func userDidInput() {
        delegate?.scoreValueChanged(input?.text ?? "")
    }

    private func configureInput(_ input: ScoreInput) {
        input.textAlignment = .center
        input.font = UIFont(name: "Consolas", size: 52.0)
        input.keyboardType = .numberPad
        addSubview(input)

        let acceptItem = UIBarButtonItem.fromSymbol(named: "checkmark.circle.fill", target: self, action: #selector(userDidAccept))
        acceptItem.tintColor = .contentPositive
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar()
        toolbar.items = [spacer, acceptItem]
        toolbar.sizeToFit()

        input.inputAccessoryView = toolbar
        input.addTarget(self, action: #selector(userDidInput), for: .allEditingEvents)
    }

    private func constrainInput() {
        input?.snp.remakeConstraints { make in
            make
                .top
                .equalTo(titleLabel.snp.bottom)
                .offset(16.0)
            make
                .leading
                .trailing
                .equalToSuperview()
                .inset(16.0)
            make
                .bottom
                .equalToSuperview()
        }
    }
}

private class ScoreInput: UITextField, Shakable {}
