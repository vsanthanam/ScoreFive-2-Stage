//
//  TappableControl.swift
//  FiveUI
//
//  Created by Varun Santhanam on 1/1/21.
//

import Foundation
import UIKit

open class TappableControl: BaseControl {
    
    // MARK: - UIControl
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isHighlighted = true
        return true
    }


    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        isHighlighted = bounds.contains(point)
        return true
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isHighlighted = false
    }
        
}
