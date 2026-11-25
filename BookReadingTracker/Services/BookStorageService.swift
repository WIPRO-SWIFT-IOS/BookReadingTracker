//
//  BookStorageService.swift
//  BookReadingTracker
//
//  Saves and loads the shelf as JSON in the app's Documents directory.
//

import Foundation

struct BookStorageService {

    private let fileURL: URL

    init(fileName: String = "books.json") {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = directory.appendingPathComponent(fileName)
    }

    /// True once something has been saved at least once.
    var hasSavedData: Bool {
        FileManager.default.fileExists(atPath: fileURL.path)
    }

    func load() -> [Book] {
        guard hasSavedData else { return [] }
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Book].self, from: data)
        } catch {
            print("BookStorageService: failed to load books – \(error.localizedDescription)")
            return []
        }
    }

    func save(_ books: [Book]) {
        do {
            let data = try JSONEncoder().encode(books)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("BookStorageService: failed to save books – \(error.localizedDescription)")
        }
    }
}
