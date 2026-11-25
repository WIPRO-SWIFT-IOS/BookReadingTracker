//
//  BookStore.swift
//  BookReadingTracker
//
//  Single source of truth for the signed-in user's shelf. Handles add / edit /
//  delete / progress updates and keeps each user's data saved in their own file.
//

import Foundation

final class BookStore: ObservableObject {

    @Published private(set) var books: [Book] = []

    /// Storage for the currently open shelf (nil while nobody is signed in).
    private var storage: BookStorageService?

    init() { }

    // MARK: Shelf lifecycle

    /// Loads the shelf that belongs to one account. New accounts start with a few sample books.
    func openShelf(for shelfID: String) {
        let newStorage = BookStorageService(fileName: "books_\(shelfID).json")
        storage = newStorage
        if newStorage.hasSavedData {
            books = newStorage.load()
        } else {
            books = Book.samples
            newStorage.save(books)
        }
    }

    /// Clears the shelf from memory (used when locking or signing out).
    func closeShelf() {
        storage = nil
        books = []
    }

    // MARK: Queries

    var stats: ReadingStats {
        ReadingStats(books: books)
    }

    func book(withID id: UUID) -> Book? {
        books.first { $0.id == id }
    }

    // MARK: Commands

    func add(_ book: Book) {
        books.insert(book, at: 0)
        persist()
    }

    func update(_ book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[index] = book
        persist()
    }

    func delete(_ book: Book) {
        delete(id: book.id)
    }

    func delete(id: UUID) {
        books.removeAll { $0.id == id }
        persist()
    }

    /// Updates pages read (clamped to 0...totalPages). Status and percentage follow automatically.
    func updateProgress(for id: UUID, pagesRead: Int) {
        guard let index = books.firstIndex(where: { $0.id == id }) else { return }
        let clamped = min(max(pagesRead, 0), books[index].totalPages)
        guard books[index].pagesRead != clamped else { return }
        books[index].pagesRead = clamped
        persist()
    }

    // MARK: Persistence

    private func persist() {
        storage?.save(books)
    }
}
