//
//  BookListViewModel.swift
//  BookReadingTracker
//
//  Search text and filters for the book list screen.
//

import Foundation

/// How the library is displayed.
enum LibraryLayout: String, CaseIterable, Identifiable {
    case list, grid, shelf

    var id: String { rawValue }

    var title: String {
        switch self {
        case .list:  return "List"
        case .grid:  return "Covers"
        case .shelf: return "Shelf"
        }
    }

    var iconName: String {
        switch self {
        case .list:  return "list.bullet"
        case .grid:  return "square.grid.2x2.fill"
        case .shelf: return "books.vertical.fill"
        }
    }
}

final class BookListViewModel: ObservableObject {

    @Published var searchText = ""
    @Published var selectedGenre: BookGenre?
    @Published var selectedStatus: ReadingStatus?
    @Published var layout: LibraryLayout = .list

    init(initialStatus: ReadingStatus? = nil) {
        selectedStatus = initialStatus
    }

    /// True when any search text or filter is active.
    var hasActiveFilters: Bool {
        !searchText.trimmed.isEmpty || selectedGenre != nil || selectedStatus != nil
    }

    func clearFilters() {
        searchText = ""
        selectedGenre = nil
        selectedStatus = nil
    }

    /// Applies search (title / author), genre and status filters.
    func filteredBooks(from books: [Book]) -> [Book] {
        let query = searchText.trimmed
        return books.filter { book in
            let matchesSearch = query.isEmpty
                || book.title.localizedCaseInsensitiveContains(query)
                || book.author.localizedCaseInsensitiveContains(query)
            let matchesGenre = selectedGenre == nil || book.genre == selectedGenre
            let matchesStatus = selectedStatus == nil || book.status == selectedStatus
            return matchesSearch && matchesGenre && matchesStatus
        }
    }
}
