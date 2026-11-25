//
//  BookCardView.swift
//  BookReadingTracker
//
//  Card used in lists: cover, title, author, genre, status and a progress bar.
//

import SwiftUI

struct BookCardView: View {
    let book: Book

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            BookCoverView(book: book, width: 62)

            VStack(alignment: .leading, spacing: 6) {
                Text(book.title)
                    .font(.system(.headline, design: .serif))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(2)

                Text("by \(book.author)")
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(book.genre.rawValue)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Theme.Colors.textSecondary)
                    StatusBadge(status: book.status)
                }

                HStack(spacing: 10) {
                    ProgressBarView(progress: book.progress, tint: book.status.tint)
                    Text("\(book.progressPercent)%")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .frame(minWidth: 36, alignment: .trailing)
                }
                .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
        .accessibilityElement(children: .combine)
    }
}
