//
//  BookDetailView.swift
//  BookReadingTracker
//
//  Full information about one book: cover, author, genre, status, stat tiles,
//  live progress tracking (slider + quick buttons) and personal notes,
//  plus Edit and Delete actions.
//

import SwiftUI

struct BookDetailView: View {

    let bookID: UUID

    @EnvironmentObject private var store: BookStore
    @Environment(\.dismiss) private var dismiss
    @State private var showEditSheet = false
    @State private var showDeleteConfirmation = false

    private let tileColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        Group {
            if let book = store.book(withID: bookID) {
                content(for: book)
            } else {
                Text("This book is no longer on your shelf.")
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showEditSheet = true
                } label: {
                    Image(systemName: "pencil")
                }
                .accessibilityLabel("Edit book")

                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .accessibilityLabel("Delete book")
            }
        }
        .sheet(isPresented: $showEditSheet) {
            if let book = store.book(withID: bookID) {
                BookFormView(mode: .edit(book))
            }
        }
        .confirmationDialog("Delete this book?",
                            isPresented: $showDeleteConfirmation,
                            titleVisibility: .visible) {
            Button("Delete Book", role: .destructive) {
                store.delete(id: bookID)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This removes the book and its notes from your shelf.")
        }
    }

    // MARK: Content

    private func content(for book: Book) -> some View {
        ScrollView {
            VStack(spacing: 18) {
                headerCard(book)
                statTiles(book)
                progressCard(book)
                notesCard(book)
            }
            .padding(Theme.Layout.screenPadding)
        }
    }

    private func headerCard(_ book: Book) -> some View {
        HStack(alignment: .top, spacing: 16) {
            BookCoverView(book: book, width: 110)

            VStack(alignment: .leading, spacing: 10) {
                Text(book.title)
                    .font(Theme.Fonts.title)
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text("by \(book.author)")
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)

                HStack(spacing: 8) {
                    StatusBadge(status: book.status)
                    Label(book.genre.rawValue, systemImage: book.genre.iconName)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.Colors.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Theme.Colors.lavender)
                        .clipShape(Capsule())
                }

                headerAction(book)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    @ViewBuilder
    private func headerAction(_ book: Book) -> some View {
        switch book.status {
        case .wantToRead:
            Button("Start reading") {
                store.updateProgress(for: book.id, pagesRead: 1)
            }
            .buttonStyle(PrimaryButtonStyle())
        case .finished:
            Button("Read it again") {
                store.updateProgress(for: book.id, pagesRead: 0)
            }
            .buttonStyle(SecondaryButtonStyle())
        case .reading:
            EmptyView()
        }
    }

    private func statTiles(_ book: Book) -> some View {
        LazyVGrid(columns: tileColumns, spacing: 12) {
            tile(title: "Total pages", value: "\(book.totalPages)", icon: "doc.plaintext.fill")
            tile(title: "Pages read", value: "\(book.pagesRead)", icon: "book.fill")
            tile(title: "Pages left", value: "\(book.pagesLeft)", icon: "hourglass")
            tile(title: "Added", value: book.dateAdded.formatted(date: .abbreviated, time: .omitted), icon: "calendar")
        }
    }

    private func tile(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(Theme.Colors.primary)
                .frame(width: 32, height: 32)
                .background(Theme.Colors.lavender)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
                Text(value)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private func progressCard(_ book: Book) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Reading Progress")
                    .font(Theme.Fonts.sectionTitle)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Spacer()
                Text("\(book.progressPercent)%")
                    .font(.title3.bold())
                    .foregroundStyle(book.status.tint)
            }

            ProgressBarView(progress: book.progress, tint: book.status.tint, height: 12)

            Text("\(book.pagesRead) of \(book.totalPages) pages read  •  \(book.pagesLeft) left")
                .font(.footnote)
                .foregroundStyle(Theme.Colors.textSecondary)

            Slider(value: pagesBinding(for: book),
                   in: 0...Double(max(book.totalPages, 1)),
                   step: 1)
                .tint(Theme.Colors.buttonFill)
                .accessibilityLabel("Pages read")

            HStack(spacing: 10) {
                quickButton("+10 pages") {
                    store.updateProgress(for: book.id, pagesRead: book.pagesRead + 10)
                }
                quickButton("+25 pages") {
                    store.updateProgress(for: book.id, pagesRead: book.pagesRead + 25)
                }
                quickButton("Finished") {
                    store.updateProgress(for: book.id, pagesRead: book.totalPages)
                }
            }

            if book.pagesRead > 0 {
                Button("Reset progress") {
                    store.updateProgress(for: book.id, pagesRead: 0)
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.Colors.danger)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private func notesCard(_ book: Book) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("My Notes", systemImage: "note.text")
                .font(Theme.Fonts.sectionTitle)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text(book.notes.isEmpty ? "No notes yet. Tap the pencil to add some." : book.notes)
                .font(.body)
                .foregroundStyle(book.notes.isEmpty ? Theme.Colors.textSecondary : Theme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    // MARK: Helpers

    private func pagesBinding(for book: Book) -> Binding<Double> {
        Binding(
            get: { Double(book.pagesRead) },
            set: { store.updateProgress(for: book.id, pagesRead: Int($0)) }
        )
    }

    private func quickButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .buttonStyle(SecondaryButtonStyle())
    }
}
