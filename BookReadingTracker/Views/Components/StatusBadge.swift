//
//  StatusBadge.swift
//  BookReadingTracker
//
//  Small pill showing Want to Read / Reading / Finished.
//

import SwiftUI

struct StatusBadge: View {
    let status: ReadingStatus

    var body: some View {
        Label(status.rawValue, systemImage: status.iconName)
            .font(.caption.weight(.semibold))
            .foregroundStyle(status.tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(status.tint.opacity(0.15))
            .clipShape(Capsule())
    }
}
