//
//  ReadingStats.swift
//  BookReadingTracker
//
//  Aggregated numbers shown on the dashboard.
//

import Foundation

struct ReadingStats {
    let totalBooks: Int
    let finishedBooks: Int
    let readingBooks: Int
    let wantToReadBooks: Int
    let totalPagesRead: Int
    let totalPages: Int

    init(books: [Book]) {
        totalBooks = books.count
        finishedBooks = books.filter { $0.status == .finished }.count
        readingBooks = books.filter { $0.status == .reading }.count
        wantToReadBooks = books.filter { $0.status == .wantToRead }.count
        totalPagesRead = books.reduce(0) { $0 + $1.pagesRead }
        totalPages = books.reduce(0) { $0 + $1.totalPages }
    }

    /// Share of all pages (across the whole shelf) that have been read.
    var overallProgress: Double {
        guard totalPages > 0 else { return 0 }
        return min(Double(totalPagesRead) / Double(totalPages), 1)
    }

    var overallPercent: Int {
        Int((overallProgress * 100).rounded())
    }
}
