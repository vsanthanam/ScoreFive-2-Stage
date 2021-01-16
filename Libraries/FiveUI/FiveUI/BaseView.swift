//
//  View.swift
//  FiveUI
//
//  Created by Varun Santhanam on 12/30/20.
//

import Foundation
import UIKit

/// A generic view subclass
open class BaseView: UIView {

    /// Create a `BaseView`
    public init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

}
