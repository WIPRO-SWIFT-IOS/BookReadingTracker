//
//  ReadingStatus.swift
//  BookReadingTracker
//
//  Reading state of a book. It is derived automatically from progress.
//

import SwiftUI

enum ReadingStatus: String, CaseIterable, Identifiable {
    case wantToRead = "Want to Read"
    case reading    = "Reading"
    case finished   = "Finished"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .wantToRead: return "bookmark.fill"
        case .reading:    return "book.fill"
        case .finished:   return "checkmark.seal.fill"
        }
    }

    var tint: Color {
        switch self {
        case .wantToRead: return Theme.Colors.accent
        case .reading:    return Theme.Colors.primary
        case .finished:   return Theme.Colors.success
        }
    }
}
