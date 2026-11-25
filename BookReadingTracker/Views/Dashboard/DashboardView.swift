//
//  DashboardView.swift
//  BookReadingTracker
//
//  Home screen: greeting, reading overview, yearly goal, stat tiles
//  (tap to open a filtered list) and quick page logging for books in progress.
//

import SwiftUI

struct DashboardView: View {

    @EnvironmentObject private var store: BookStore
    @EnvironmentObject private var auth: AuthViewModel
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showAddBook = false
    @State private var showGoalEditor = false

    private let columns = [
        GridItem(.flexible(), spacing: Theme.Layout.spacing),
        GridItem(.flexible(), spacing: Theme.Layout.spacing)
    ]

    var body: some View {
        let stats = store.stats

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    greetingHeader
                    overviewBanner(stats)
                    statsGrid(stats)
                    goalCard(stats)
                    currentlyReadingSection
                    recentlyAddedSection
                }
                .padding(Theme.Layout.screenPadding)
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        if let user = auth.currentUser {
                            Text(user.name)
                        }
                        Button {
                            auth.lock()
                        } label: {
                            Label("Lock now", systemImage: "lock.fill")
                        }
                        Button(role: .destructive) {
                            auth.signOut()
                        } label: {
                            Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                    }
                    .accessibilityLabel("Account menu")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddBook = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityLabel("Add book")
                }
            }
            .sheet(isPresented: $showAddBook) {
                BookFormView(mode: .add)
            }
            .sheet(isPresented: $showGoalEditor) {
                GoalEditorView(viewModel: viewModel)
            }
        }
    }

    // MARK: Sections

    private var greetingText: String {
        guard let first = auth.currentUser?.name.split(separator: " ").first else {
            return viewModel.greeting
        }
        return "\(viewModel.greeting), \(first)"
    }

    private var greetingHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greetingText)
                .font(Theme.Fonts.largeTitle)
                .foregroundStyle(Theme.Colors.textPrimary)
            Text(viewModel.dateText)
                .font(.subheadline)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
    }

    private func overviewBanner(_ stats: ReadingStats) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Reading Journey")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.white.opacity(0.85))

            Text("\(stats.overallPercent)% of your shelf read")
                .font(Theme.Fonts.title)
                .foregroundStyle(Color.white)

            ProgressBarView(
                progress: stats.overallProgress,
                tint: Color.white,
                trackColor: Color.white.opacity(0.25),
                height: 10
            )

            Text("\(stats.totalPagesRead.formatted()) of \(stats.totalPages.formatted()) pages")
                .font(.footnote)
                .foregroundStyle(Color.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Theme.headerGradient)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func statsGrid(_ stats: ReadingStats) -> some View {
        LazyVGrid(columns: columns, spacing: Theme.Layout.spacing) {
            NavigationLink {
                BookListView()
            } label: {
                StatCardView(title: "Total Books", value: stats.totalBooks,
                             iconName: "books.vertical.fill", tint: Theme.Colors.primary)
            }
            .buttonStyle(.plain)

            NavigationLink {
                BookListView(initialStatus: .finished)
            } label: {
                StatCardView(title: "Books Finished", value: stats.finishedBooks,
                             iconName: "checkmark.seal.fill", tint: Theme.Colors.success)
            }
            .buttonStyle(.plain)

            NavigationLink {
                BookListView(initialStatus: .reading)
            } label: {
                StatCardView(title: "Currently Reading", value: stats.readingBooks,
                             iconName: "book.fill", tint: Theme.Colors.buttonFill)
            }
            .buttonStyle(.plain)

            StatCardView(title: "Pages Read", value: stats.totalPagesRead,
                         iconName: "doc.text.fill", tint: Theme.Colors.accent)
        }
    }

    private func goalCard(_ stats: ReadingStats) -> some View {
        HStack(spacing: 18) {
            GoalRingView(
                progress: viewModel.goalProgress(finishedBooks: stats.finishedBooks),
                centerText: "\(stats.finishedBooks)/\(viewModel.yearlyGoal)"
            )
            .frame(width: 96, height: 96)

            VStack(alignment: .leading, spacing: 6) {
                Text("Reading Goal")
                    .font(Theme.Fonts.sectionTitle)
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text(goalMessage(stats))
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)

                Button("Change goal") {
                    showGoalEditor = true
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.Colors.primary)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private func goalMessage(_ stats: ReadingStats) -> String {
        let toGo = viewModel.booksToGo(finishedBooks: stats.finishedBooks)
        if toGo == 0 {
            return "Goal reached. Amazing reading!"
        }
        return toGo == 1 ? "1 book to go this year." : "\(toGo) books to go this year."
    }

    private var currentlyReadingSection: some View {
        let reading = store.books.filter { $0.status == .reading }

        return VStack(alignment: .leading, spacing: 12) {
            Text("Continue Reading")
                .font(Theme.Fonts.sectionTitle)
                .foregroundStyle(Theme.Colors.textPrimary)

            if reading.isEmpty {
                Text("Nothing in progress. Open a book and update its pages to start tracking.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
            } else {
                ForEach(reading.prefix(3)) { book in
                    readingRow(book)
                }
            }
        }
    }

    private var recentlyAddedSection: some View {
        let recent = store.books.sorted { $0.dateAdded > $1.dateAdded }.prefix(8)

        return VStack(alignment: .leading, spacing: 12) {
            Text("Recently Added")
                .font(Theme.Fonts.sectionTitle)
                .foregroundStyle(Theme.Colors.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(Array(recent)) { book in
                        NavigationLink {
                            BookDetailView(bookID: book.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                BookCoverView(book: book, width: 92)
                                Text(book.title)
                                    .font(.system(.caption, design: .serif).weight(.semibold))
                                    .foregroundStyle(Theme.Colors.textPrimary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: 92, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    /// Book card with quick "+10 / +25 pages" buttons so progress can be logged from the home screen.
    private func readingRow(_ book: Book) -> some View {
        VStack(spacing: 10) {
            NavigationLink {
                BookDetailView(bookID: book.id)
            } label: {
                BookCardView(book: book)
            }
            .buttonStyle(.plain)

            HStack(spacing: 10) {
                Button("+10 pages") {
                    store.updateProgress(for: book.id, pagesRead: book.pagesRead + 10)
                }
                .buttonStyle(SecondaryButtonStyle())

                Button("+25 pages") {
                    store.updateProgress(for: book.id, pagesRead: book.pagesRead + 25)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }
}
