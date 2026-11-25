//
//  Book.swift
//  BookReadingTracker
//
//  Core data model for one book on the shelf.
//

import Foundation

struct Book: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var author: String
    var genre: BookGenre
    var totalPages: Int
    var pagesRead: Int
    var notes: String
    var dateAdded = Date()

    // MARK: Derived values

    /// Progress from 0.0 to 1.0.
    var progress: Double {
        guard totalPages > 0 else { return 0 }
        return min(max(Double(pagesRead) / Double(totalPages), 0), 1)
    }

    /// Progress rounded to a whole percentage (0...100).
    var progressPercent: Int {
        Int((progress * 100).rounded())
    }

    /// Automatically labelled from progress: Want to Read, Reading or Finished.
    var status: ReadingStatus {
        if pagesRead <= 0 {
            return .wantToRead
        } else if pagesRead >= totalPages {
            return .finished
        } else {
            return .reading
        }
    }

    var pagesLeft: Int {
        max(totalPages - pagesRead, 0)
    }
}
