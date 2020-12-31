//
//  TextField.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/31/20.
//

import Foundation
import UIKit
import FiveUI
import SnapKit

protocol TextFieldProperties: AnyObject {
    var textColor: UIColor? { get set }
    var text: String? { get set }
    var font: UIFont? { get set }
    var placeholder: String? { get set }
    var textAlignment: NSTextAlignment { get set }
    var clearButtonMode: UITextField.ViewMode { get set }
    var autocapitalizationType: UITextAutocapitalizationType { get set }
    var autocorrectionType: UITextAutocorrectionType { get set }
    var spellCheckingType: UITextSpellCheckingType { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var keyboardType: UIKeyboardType { get set }
}

@dynamicMemberLookup
class TextField: BaseControl {
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        setUp()
    }
    
    // MARK: - API
    
    var inputBackgroundColor: UIColor? {
        get {
            input.backgroundColor
        }
        set {
            input.backgroundColor = newValue
        }
    }
    
    var placeholderColor: UIColor? {
        get {
            input.placeholderColor
        }
        set {
            input.placeholderColor = newValue
        }
    }
    
    var contentInset: UIEdgeInsets  {
        get {
            input.contentInset
        }
        set {
            input.contentInset = newValue
        }
    }
    
    // MARK: - DynamicMemberLookup
    
    subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<TextFieldProperties, T>) -> T {
        get {
            input[keyPath: keyPath]
        }
        set {
            input[keyPath: keyPath] = newValue
        }
    }
    
    // MARK: - UIControl
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        input.addTarget(target, action: action, for: controlEvents)
    }
    
    override func removeTarget(_ target: Any?,
                               action: Selector?,
                               for controlEvents: UIControl.Event) {
        input.removeTarget(target,
                           action: action,
                           for: controlEvents)
    }
    
    override func actions(forTarget target: Any?,
                          forControlEvent controlEvent: UIControl.Event) -> [String]? {
        input.actions(forTarget: target,
                      forControlEvent: controlEvent)
    }
    
    override var allControlEvents: UIControl.Event {
        input.allControlEvents
    }
    
    override var allTargets: Set<AnyHashable> {
        input.allTargets
    }
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        input.sendAction(action, to: target, for: event)
    }
    
    override func sendActions(for controlEvents: UIControl.Event) {
        input.sendActions(for: controlEvents)
    }
    
    override func addAction(_ action: UIAction,
                            for controlEvents: UIControl.Event) {
        input.addAction(action, for: controlEvents)
    }
    
    override func removeAction(_ action: UIAction,
                               for controlEvents: UIControl.Event) {
        input.removeAction(action, for: controlEvents)
    }
    
    override func removeAction(identifiedBy actionIdentifier: UIAction.Identifier,
                               for controlEvents: UIControl.Event) {
        input.removeAction(identifiedBy: actionIdentifier, for: controlEvents)
    }
    
    override func sendAction(_ action: UIAction) {
        input.sendAction(action)
    }
    
    // MARK: - Private
    
    private let input = Input()
    private let border = UIView()
    
    private func setUp() {
        input.borderStyle = .none
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        input.leftViewMode = .always
        input.leftView = spacerView
        self.textColor = .contentPrimary
        inputBackgroundColor = .backgroundSecondary
        backgroundColor = .transparent
        
        input.font = .systemFont(ofSize: 16.0)
        addSubview(input)
        input.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        border.backgroundColor = .contentPrimary
        addSubview(border)
        border.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(2.0)
        }
    }
    
    fileprivate class Input: UITextField {
        
        var contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 10) {
            didSet {
                setNeedsDisplay()
            }
        }
        
        var placeholderColor: UIColor? = .controlDisabled
        
        override func drawPlaceholder(in rect: CGRect) {
            placeholderColor?.setFill()
            placeholder?.draw(in: rect, withAttributes: [.font: font ?? .systemFont(ofSize: 16.0),
                                                         .foregroundColor: placeholderColor ?? .controlDisabled])
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            bounds.inset(by: contentInset)
        }

        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            bounds.inset(by: contentInset)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            bounds.inset(by: contentInset)
        }
    }
}

extension TextField.Input: TextFieldProperties {}
