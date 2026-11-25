//
//  BookGridView.swift
//  BookReadingTracker
//
//  Cover grid layout for the library (like a bookstore display).
//

import SwiftUI

struct BookGridView: View {
    let books: [Book]
    let onDelete: (Book) -> Void

    private let columns = [GridItem(.adaptive(minimum: 104), spacing: 16, alignment: .top)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(books) { book in
                    NavigationLink {
                        BookDetailView(bookID: book.id)
                    } label: {
                        cell(book)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            onDelete(book)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(Theme.Layout.screenPadding)
        }
    }

    private func cell(_ book: Book) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            BookCoverView(book: book, width: 104)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: book.status.iconName)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.white)
                        .padding(6)
                        .background(book.status.tint)
                        .clipShape(Circle())
                        .padding(5)
                }

            ProgressBarView(progress: book.progress, tint: book.status.tint, height: 6)

            Text(book.title)
                .font(.system(.footnote, design: .serif).weight(.semibold))
                .foregroundStyle(Theme.Colors.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Text("\(book.progressPercent)%  •  \(book.status.rawValue)")
                .font(.caption2)
                .foregroundStyle(Theme.Colors.textSecondary)
                .lineLimit(1)
        }
        .frame(width: 104, alignment: .leading)
    }
}
