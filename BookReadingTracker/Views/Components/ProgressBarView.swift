//
//  ProgressBarView.swift
//  BookReadingTracker
//
//  Capsule progress bar (0.0 ... 1.0) that animates when the value changes.
//

import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    var tint: Color = Theme.Colors.primary
    var trackColor: Color = Theme.Colors.lavender
    var height: CGFloat = 8

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(trackColor)
                Capsule()
                    .fill(tint)
                    .frame(width: proxy.size.width * CGFloat(clampedProgress))
            }
        }
        .frame(height: height)
        .animation(.easeInOut(duration: 0.25), value: clampedProgress)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Reading progress")
        .accessibilityValue("\(Int((clampedProgress * 100).rounded())) percent")
    }
}
