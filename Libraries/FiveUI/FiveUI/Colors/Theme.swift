//
//  Theme.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import Foundation
import UIKit

extension UIColor {
    
    // MARK: - Semantic Colors
    
    public static var transparent: UIColor {
        ColorPalette.Transparent
    }
    
    public static var shadowColor: UIColor {
        dynamicDarkPrimary
    }
    
    public static var backgroundPrimary: UIColor {
        dynamicLightPrimary
    }
    
    public static var backgroundSecondary: UIColor {
        dynamicLightSecondary
    }
    
    public static var backgroundInversePrimary: UIColor {
        dynamicDarkPrimary
    }
    
    public static var backgroundInverseSecondary: UIColor {
        dynamicDarkSecondary
    }
    
    public static var contentPrimary: UIColor {
        dynamicDarkPrimary
    }
    
    public static var contentSecondary: UIColor {
        dynamicDarkSecondary
    }
    
    public static var contentInversePrimary: UIColor {
        dynamicLightPrimary
    }
    
    public static var contentInverseSecondary: UIColor {
        dynamicLightSecondary
    }
    
    public static var contentOnColorPrimary: UIColor {
        staticLightPrimary
    }
    
    public static var contentOnColorSecondary: UIColor {
        staticLightSecondary
    }
    
    public static var contentOnColorInversePrimary: UIColor {
        staticDarkPrimary
    }
    
    public static var contentOnColorInverseSecondary: UIColor {
        staticDarkSecondary
    }
    
    public static var contentAccentPrimary: UIColor {
        staticThemePrimary
    }
    
    public static var contentAccentSecondary: UIColor {
        staticThemeSecondary
    }
    
    // MARK: - Implementation Colors
    
    private static let staticDarkPrimary: UIColor = ColorPalette.Black
    
    private static let staticDarkSecondary: UIColor = ColorPalette.Grey800
    
    private static let staticLightPrimary: UIColor = ColorPalette.White
    
    private static let staticLightSecondary: UIColor = ColorPalette.Grey200
    
    private static var staticThemePrimary: UIColor = ColorPalette.Blue500
    private static var staticThemeSecondary: UIColor = ColorPalette.Blue700
    
    private static var dynamicDarkPrimary: UIColor {
        .init { traitCollection in
            switch traitCollection.themeStyle {
            case .light: return staticDarkPrimary
            case .dark: return staticLightPrimary
            }
        }
    }
    
    private static var dynamicDarkSecondary: UIColor {
        .init { traitCollection in
            switch traitCollection.themeStyle {
            case .light: return staticDarkSecondary
            case .dark: return staticLightSecondary
            }
        }
    }
    
    private static var dynamicLightPrimary: UIColor {
        .init { traitCollection in
            switch traitCollection.themeStyle {
            case .light: return staticLightPrimary
            case .dark: return staticDarkPrimary
            }
        }
    }
    
    private static var dynamicLightSecondary: UIColor {
        .init { traitCollection in
            switch traitCollection.themeStyle {
            case .light: return staticLightSecondary
            case .dark: return staticDarkSecondary
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
