//
//  BaseControl.swift
//  FiveUI
//
//  Created by Varun Santhanam on 12/30/20.
//

import Foundation
import UIKit

/// A beneric `UIControl` subclass
open class BaseControl: UIControl {

    /// Create a `BaseControl`
    public init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

}
