//
//  BookShelfView.swift
//  BookReadingTracker
//
//  Bookshelf layout: books stand as spines on wooden shelves. Tap a spine to open it.
//

import SwiftUI

struct BookShelfView: View {
    let books: [Book]

    private let booksPerShelf = 6

    private var shelves: [[Book]] {
        stride(from: 0, to: books.count, by: booksPerShelf).map { start in
            Array(books[start..<min(start + booksPerShelf, books.count)])
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                ForEach(Array(shelves.enumerated()), id: \.offset) { _, shelf in
                    shelfRow(shelf)
                }
            }
            .padding(Theme.Layout.screenPadding)
        }
    }

    private func shelfRow(_ shelf: [Book]) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 5) {
                ForEach(shelf) { book in
                    NavigationLink {
                        BookDetailView(bookID: book.id)
                    } label: {
                        BookSpineView(book: book)
                    }
                    .buttonStyle(.plain)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)

            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Theme.Colors.wood)
                .frame(height: 12)
                .shadow(color: Theme.Colors.shadow, radius: 4, x: 0, y: 4)
        }
    }
}
