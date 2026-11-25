//
//  StatCardView.swift
//  BookReadingTracker
//
//  Dashboard tile showing one number with an icon.
//

import SwiftUI

struct StatCardView: View {
    let title: String
    let value: Int
    let iconName: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: iconName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 40, height: 40)
                .background(tint.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(value.formatted())
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.Colors.textPrimary)
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
        .accessibilityElement(children: .combine)
    }
}
