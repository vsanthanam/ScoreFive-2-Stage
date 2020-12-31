//
//  UIViewController+FiveUI.swift
//  FiveUI
//
//  Created by Varun Santhanam on 12/30/20.
//

import Foundation
import UIKit

public extension UIViewController {
    
    /// A generic interface to use a UIAlertController to display an error
    /// - Parameters:
    ///   - error: the error
    ///   - title: The title of the error message
    func displayError(_ error: Error, title: String) {
        let controller = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
}
