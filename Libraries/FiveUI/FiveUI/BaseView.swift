//
//  View.swift
//  FiveUI
//
//  Created by Varun Santhanam on 12/30/20.
//

import Foundation
import UIKit

open class BaseView: UIView {

    public init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

}
