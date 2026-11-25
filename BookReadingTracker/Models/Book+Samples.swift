//
//  Book+Samples.swift
//  BookReadingTracker
//
//  Starter books shown the first time the app launches.
//

import Foundation

extension Book {
    static var samples: [Book] {
        [
            Book(title: "Atomic Habits", author: "James Clear", genre: .selfHelp,
                 totalPages: 320, pagesRead: 140,
                 notes: "Habit stacking and the 1% rule are worth revisiting."),
            Book(title: "Clean Code", author: "Robert C. Martin", genre: .technology,
                 totalPages: 464, pagesRead: 464,
                 notes: "Great chapters on naming and small functions."),
            Book(title: "Sapiens", author: "Yuval Noah Harari", genre: .history,
                 totalPages: 498, pagesRead: 0,
                 notes: "Recommended by a friend."),
            Book(title: "The Alchemist", author: "Paulo Coelho", genre: .fiction,
                 totalPages: 208, pagesRead: 208,
                 notes: "A short and inspiring read."),
            Book(title: "Steve Jobs", author: "Walter Isaacson", genre: .biography,
                 totalPages: 656, pagesRead: 120,
                 notes: "")
        ]
    }
}
