//
//  Theme.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import UIKit

extension UIColor {
    static var backgroundPrimary: UIColor {
        .init { traitCollection in
            switch traitCollection.themeStyle {
            case .light: return ColorPalette.white
            case .dark: return ColorPalette.black
            }
        }
    }
}

fileprivate enum ThemeStyle {
    case light
    case dark
}

fileprivate extension UIUserInterfaceStyle {
    var asThemeStyle: ThemeStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .unspecified:
            return .light
        @unknown default:
            return .light
        }
    }
}

fileprivate extension UITraitCollection {
    var themeStyle: ThemeStyle {
        userInterfaceStyle.asThemeStyle
    }
}
