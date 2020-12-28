//
//  View.swift
//  ShortRibs
//
//  Created by Varun Santhanam on 12/8/20.
//

import Foundation
import UIKit

open class ScopeView: UIView {
    
    // MARK: - Initializers
    
    public init() {
        super.init(frame: .zero)
    }

    // MARK: - Unavailable
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Don't use interface builder 😡")
    }
    
}
