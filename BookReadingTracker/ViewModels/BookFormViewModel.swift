//
//  BookFormViewModel.swift
//  BookReadingTracker
//
//  Form state + validation shared by the Add Book and Edit Book screens.
//

import Foundation

enum BookFormMode {
    case add
    case edit(Book)

    var isEditing: Bool {
        if case .edit = self { return true }
        return false
    }
}

final class BookFormViewModel: ObservableObject {

    enum Field {
        case title, author, totalPages, pagesRead
    }

    @Published var title = ""
    @Published var author = ""
    @Published var genre: BookGenre = .fiction
    @Published var totalPagesText = ""
    @Published var pagesReadText = ""
    @Published var notes = ""
    @Published private(set) var errors: [Field: String] = [:]

    let mode: BookFormMode
    private var existingBook: Book?

    init(mode: BookFormMode) {
        self.mode = mode
        if case .edit(let book) = mode {
            existingBook = book
            title = book.title
            author = book.author
            genre = book.genre
            totalPagesText = String(book.totalPages)
            pagesReadText = String(book.pagesRead)
            notes = book.notes
        }
    }

    var screenTitle: String {
        mode.isEditing ? "Edit Book" : "Add Book"
    }

    var saveButtonTitle: String {
        mode.isEditing ? "Save Changes" : "Add to Shelf"
    }

    /// Validates every field. Returns true when the form can be saved.
    func validate() -> Bool {
        var newErrors: [Field: String] = [:]

        if Validators.isBlank(title) {
            newErrors[.title] = "Title is required."
        }
        if Validators.isBlank(author) {
            newErrors[.author] = "Author is required."
        }

        let total = Int(totalPagesText.trimmed)
        if let total = total, total > 0 {
            if mode.isEditing {
                let readText = pagesReadText.trimmed
                if !readText.isEmpty {
                    if let read = Int(readText), read >= 0 {
                        if read > total {
                            newErrors[.pagesRead] = "Pages read can't be more than total pages."
                        }
                    } else {
                        newErrors[.pagesRead] = "Enter a valid number of pages."
                    }
                }
            }
        } else {
            newErrors[.totalPages] = "Enter total pages as a whole number above 0."
        }

        errors = newErrors
        return newErrors.isEmpty
    }

    /// Builds the Book to store. Call only after `validate()` returned true.
    func makeBook() -> Book {
        let total = Int(totalPagesText.trimmed) ?? 1
        let read = min(max(Int(pagesReadText.trimmed) ?? 0, 0), total)

        if var book = existingBook {
            book.title = title.trimmed
            book.author = author.trimmed
            book.genre = genre
            book.totalPages = total
            book.pagesRead = read
            book.notes = notes.trimmed
            return book
        }

        return Book(
            title: title.trimmed,
            author: author.trimmed,
            genre: genre,
            totalPages: total,
            pagesRead: 0,
            notes: notes.trimmed
        )
    }
}
