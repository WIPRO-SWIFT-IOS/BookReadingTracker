//
//  MainTabView.swift
//  BookReadingTracker
//
//  Bottom tab bar: Dashboard (home) and Library (book list).
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }

            NavigationStack {
                BookListView()
            }
            .tabItem {
                Label("Library", systemImage: "books.vertical.fill")
            }
        }
        .tint(Theme.Colors.primary)
    }
}
