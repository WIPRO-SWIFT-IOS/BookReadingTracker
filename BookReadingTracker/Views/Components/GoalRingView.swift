//
//  GoalRingView.swift
//  BookReadingTracker
//
//  Circular progress ring used for the yearly reading goal.
//

import SwiftUI

struct GoalRingView: View {
    let progress: Double
    let centerText: String
    var lineWidth: CGFloat = 12

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Theme.Colors.lavender, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: clampedProgress)
                .stroke(Theme.Colors.buttonFill,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: clampedProgress)

            Text(centerText)
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.Colors.textPrimary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Yearly goal progress")
        .accessibilityValue("\(Int((clampedProgress * 100).rounded())) percent")
    }
}
