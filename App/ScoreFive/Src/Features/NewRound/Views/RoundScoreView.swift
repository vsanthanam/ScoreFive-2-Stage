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
        input.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        input.resignFirstResponder()
    }

    func clear() {
        input.shake()
        input.text = ""
    }
    
    private let input = ScoreInput()
    
    private func setUp() {
        backgroundColor = .backgroundPrimary
        input.textAlignment = .center
        input.font = UIFont(name: "Consolas", size: 52.0)
        input.keyboardType = .numberPad
        addSubview(input)
        input.snp.makeConstraints { make in
            make
                .center
                .equalToSuperview()
            make
                .leading
                .trailing
                .equalToSuperview()
                .inset(16.0)
        }
        
        let acceptItem = UIBarButtonItem.fromSymbol(named: "checkmark.circle.fill", target: self, action: #selector(userDidAccept))
        acceptItem.tintColor = .contentPositive
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar()
        toolbar.items = [spacer, acceptItem]
        toolbar.sizeToFit()
        
        input.inputAccessoryView = toolbar
        input.addTarget(self, action: #selector(userDidInput), for: .allEditingEvents)
    }
    
    @objc
    private func userDidAccept() {
        delegate?.scoreDidAccept()
    }
    
    @objc
    private func userDidInput() {
        delegate?.scoreValueChanged(input.text ?? "")
    }
}

fileprivate final class ScoreInput: UITextField, Shakable {}
