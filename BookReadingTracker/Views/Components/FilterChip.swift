//
//  FilterChip.swift
//  BookReadingTracker
//
//  Selectable pill used for the genre and status filters.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundStyle(isSelected ? Color.white : Theme.Colors.textPrimary)
                .background(isSelected ? Theme.Colors.buttonFill : Theme.Colors.lavender)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
