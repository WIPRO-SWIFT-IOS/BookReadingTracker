//
//  BookReadingTrackerApp.swift
//  BookReadingTracker
//
//  App entry point. Creates the shared view models and injects them into the environment.
//

import SwiftUI

@main
struct BookReadingTrackerApp: App {

    @StateObject private var bookStore: BookStore
    @StateObject private var authViewModel: AuthViewModel

    init() {
        let store = BookStore()
        _bookStore = StateObject(wrappedValue: store)
        _authViewModel = StateObject(wrappedValue: AuthViewModel(bookStore: store))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(bookStore)
        }
    }
}
