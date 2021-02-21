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

    public static var backgroundTertiary: UIColor {
        dynamicLightTertiary
    }

    public static var backgroundInversePrimary: UIColor {
        dynamicDarkPrimary
    }

    public static var backgroundInverseSecondary: UIColor {
        dynamicDarkSecondary
    }

    public static var backgrondInverserTertiary: UIColor {
        dynamicDarkTertiary
    }

    public static var contentPrimary: UIColor {
        dynamicDarkPrimary
    }

    public static var contentSecondary: UIColor {
        dynamicDarkSecondary
    }

    public static var contentTertiary: UIColor {
        dynamicDarkTertiary
    }

    public static var contentInversePrimary: UIColor {
        dynamicLightPrimary
    }

    public static var contentInverseSecondary: UIColor {
        dynamicLightSecondary
    }

    public static var contentInverseTertiary: UIColor {
        dynamicLightTertiary
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

    public static var contentOnColorInverseTertiary: UIColor {
        staticDarkTertiary
    }

    public static var contentAccentPrimary: UIColor {
        staticThemePrimary
    }

    public static var contentAccentSecondary: UIColor {
        staticThemeSecondary
    }

    public static var controlDisabled: UIColor {
        ColorPalette.Grey500
    }

    public static var contentPositive: UIColor {
        ColorPalette.Green700
    }

    public static var contentNegative: UIColor {
        ColorPalette.Red700
    }

    // MARK: - Implementation Colors

    private static let staticDarkPrimary: UIColor = ColorPalette.Black

    private static let staticDarkSecondary: UIColor = ColorPalette.Grey800

    private static let staticDarkTertiary: UIColor = ColorPalette.Grey600

    private static let staticLightPrimary: UIColor = ColorPalette.White

    private static let staticLightSecondary: UIColor = ColorPalette.Grey200

    private static let staticLightTertiary: UIColor = ColorPalette.Grey400

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

    private static var dynamicDarkTertiary: UIColor {
        .init { traitCollection in
            switch traitCollection.themeStyle {
            case .light: return staticDarkTertiary
            case .dark: return staticLightTertiary
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

    private static var dynamicLightTertiary: UIColor {
        .init { traitCollection in
            switch traitCollection.themeStyle {
            case .light: return staticLightTertiary
            case .dark: return staticDarkTertiary
            }
        }
    }
}

private enum ThemeStyle {
    case light
    case dark
}

private extension UIUserInterfaceStyle {
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

private extension UITraitCollection {
    var themeStyle: ThemeStyle {
        userInterfaceStyle.asThemeStyle
    }
}
