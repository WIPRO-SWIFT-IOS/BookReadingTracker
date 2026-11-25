//
//  Theme.swift
//  BookReadingTracker
//
//  Central design system: colours (light + dark), gradients and layout constants.
//  Every screen reads its styling from here so the app stays visually consistent.
//

import SwiftUI
import UIKit

// MARK: - Colour helpers

extension UIColor {
    /// Creates a colour from a 0xRRGGBB hex value.
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha
        )
    }
}

extension Color {
    /// A colour that automatically switches between a light and a dark value.
    init(light: UInt32, dark: UInt32) {
        self.init(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        })
    }
}

// MARK: - Theme

enum Theme {

    /// Lavender / purple palette with light and dark variants.
    enum Colors {
        static let background    = Color(light: 0xF5F1FF, dark: 0x120D1F)
        static let card          = Color(light: 0xFFFFFF, dark: 0x241B3D)
        static let lavender      = Color(light: 0xE9E1FB, dark: 0x3A2D5C)
        static let primary       = Color(light: 0x6D3FD6, dark: 0xB4A0FA)
        static let buttonFill    = Color(light: 0x5B2FC7, dark: 0x7C5CE6)
        static let textPrimary   = Color(light: 0x1E1433, dark: 0xF4F0FF)
        static let textSecondary = Color(light: 0x6A6089, dark: 0xBDB2DB)
        static let accent        = Color(light: 0xB45309, dark: 0xFBBF24)
        static let success       = Color(light: 0x15803D, dark: 0x4ADE80)
        static let danger        = Color(light: 0xDC2626, dark: 0xF87171)
        static let wood          = Color(light: 0x8A6A4F, dark: 0x5C4636)
        static let shadow        = Color.black.opacity(0.10)
    }

    /// Deep-purple gradient used for hero banners (white text sits on top).
    static let headerGradient = LinearGradient(
        colors: [Color(UIColor(hex: 0x3B1F82)), Color(UIColor(hex: 0x8B5CF6))],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Serif headings give the app its bookish feel.
    enum Fonts {
        static let largeTitle = Font.system(.title, design: .serif).weight(.bold)
        static let title = Font.system(.title2, design: .serif).weight(.bold)
        static let sectionTitle = Font.system(.title3, design: .serif).weight(.bold)
    }

    enum Layout {
        static let cornerRadius: CGFloat = 18
        static let screenPadding: CGFloat = 16
        static let spacing: CGFloat = 14
    }
}
