//
//  CardStyle.swift
//  BookReadingTracker
//
//  Shared "card" look: rounded white/dark surface with a soft shadow.
//

import SwiftUI

struct CardStyle: ViewModifier {
    var padding: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Theme.Colors.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius, style: .continuous))
            .shadow(color: Theme.Colors.shadow, radius: 8, x: 0, y: 4)
    }
}

extension View {
    func cardStyle(padding: CGFloat = 16) -> some View {
        modifier(CardStyle(padding: padding))
    }
}
