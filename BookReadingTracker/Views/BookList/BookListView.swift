//
//  BookListView.swift
//  BookReadingTracker
//
//  Library screen: search (title / author), genre + status filters and three
//  layouts – card list (swipe to delete), cover grid and bookshelf.
//

import SwiftUI

struct BookListView: View {

    @EnvironmentObject private var store: BookStore
    @StateObject private var viewModel: BookListViewModel
    @State private var showAddBook = false

    init(initialStatus: ReadingStatus? = nil) {
        _viewModel = StateObject(wrappedValue: BookListViewModel(initialStatus: initialStatus))
    }

    var body: some View {
        let books = viewModel.filteredBooks(from: store.books)

        VStack(spacing: 0) {
            filterBar

            if books.isEmpty {
                emptyState
            } else {
                switch viewModel.layout {
                case .list:
                    bookList(books)
                case .grid:
                    BookGridView(books: books) { book in
                        store.delete(book)
                    }
                case .shelf:
                    BookShelfView(books: books)
                }
            }
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("My Library")
        .searchable(text: $viewModel.searchText, prompt: "Search title or author")
        .toolbar {
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
    }

    // MARK: Filters

    private var filterBar: some View {
        VStack(spacing: 10) {
            Picker("Layout", selection: $viewModel.layout) {
                ForEach(LibraryLayout.allCases) { layout in
                    Label(layout.title, systemImage: layout.iconName).tag(layout)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Theme.Layout.screenPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "All Genres", isSelected: viewModel.selectedGenre == nil) {
                        viewModel.selectedGenre = nil
                    }
                    ForEach(BookGenre.allCases) { genre in
                        FilterChip(title: genre.rawValue, isSelected: viewModel.selectedGenre == genre) {
                            viewModel.selectedGenre = genre
                        }
                    }
                }
                .padding(.horizontal, Theme.Layout.screenPadding)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "Any Status", isSelected: viewModel.selectedStatus == nil) {
                        viewModel.selectedStatus = nil
                    }
                    ForEach(ReadingStatus.allCases) { status in
                        FilterChip(title: status.rawValue, isSelected: viewModel.selectedStatus == status) {
                            viewModel.selectedStatus = status
                        }
                    }
                }
                .padding(.horizontal, Theme.Layout.screenPadding)
            }
        }
        .padding(.vertical, 10)
    }

    // MARK: List layout

    private func bookList(_ books: [Book]) -> some View {
        List {
            ForEach(books) { book in
                ZStack {
                    BookCardView(book: book)
                    NavigationLink {
                        BookDetailView(bookID: book.id)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 6, leading: Theme.Layout.screenPadding,
                                          bottom: 6, trailing: Theme.Layout.screenPadding))
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        store.delete(book)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    // MARK: Empty state

    private var emptyState: some View {
        VStack(spacing: 14) {
            Spacer()

            Image("EmptyShelf")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .accessibilityHidden(true)

            Text(viewModel.hasActiveFilters ? "No matching books" : "Your shelf is empty")
                .font(Theme.Fonts.sectionTitle)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text(viewModel.hasActiveFilters
                 ? "Try a different search or clear your filters."
                 : "Add your first book to start tracking your reading.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.Colors.textSecondary)
                .padding(.horizontal, 32)

            if viewModel.hasActiveFilters {
                Button("Clear Filters") {
                    viewModel.clearFilters()
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal, 60)
            } else {
                Button("Add a Book") {
                    showAddBook = true
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 60)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
