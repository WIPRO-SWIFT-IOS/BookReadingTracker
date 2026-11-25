//
//  BookGenre.swift
//  BookReadingTracker
//
//  The genres a book can belong to (used by the form and the genre filter).
//

import Foundation

enum BookGenre: String, CaseIterable, Codable, Identifiable {
    case fiction     = "Fiction"
    case technology  = "Technology"
    case biography   = "Biography"
    case selfHelp    = "Self-help"
    case history     = "History"
    case science     = "Science"
    case fantasy     = "Fantasy"
    case other       = "Other"

    var id: String { rawValue }

    /// SF Symbol shown on cards.
    var iconName: String {
        switch self {
        case .fiction:    return "book.closed.fill"
        case .technology: return "laptopcomputer"
        case .biography:  return "person.text.rectangle.fill"
        case .selfHelp:   return "lightbulb.fill"
        case .history:    return "building.columns.fill"
        case .science:    return "atom"
        case .fantasy:    return "sparkles"
        case .other:      return "books.vertical.fill"
        }
    }
}
