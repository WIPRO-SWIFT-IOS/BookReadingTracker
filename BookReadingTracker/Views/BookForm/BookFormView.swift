//
//  BookFormView.swift
//  BookReadingTracker
//
//  One form used for both "Add Book" and "Edit Book".
//

import SwiftUI

struct BookFormView: View {

    @EnvironmentObject private var store: BookStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: BookFormViewModel

    init(mode: BookFormMode) {
        _viewModel = StateObject(wrappedValue: BookFormViewModel(mode: mode))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Book Info") {
                    TextField("Title", text: $viewModel.title)
                        .textInputAutocapitalization(.words)
                    errorRow(for: .title)

                    TextField("Author", text: $viewModel.author)
                        .textInputAutocapitalization(.words)
                    errorRow(for: .author)

                    Picker("Genre", selection: $viewModel.genre) {
                        ForEach(BookGenre.allCases) { genre in
                            Text(genre.rawValue).tag(genre)
                        }
                    }
                    .tint(Theme.Colors.primary)
                }

                Section("Pages") {
                    TextField("Total pages", text: $viewModel.totalPagesText)
                        .keyboardType(.numberPad)
                    errorRow(for: .totalPages)

                    if viewModel.mode.isEditing {
                        TextField("Pages read", text: $viewModel.pagesReadText)
                            .keyboardType(.numberPad)
                        errorRow(for: .pagesRead)
                    }
                }

                Section("Notes") {
                    TextEditor(text: $viewModel.notes)
                        .frame(minHeight: 110)
                }

                Section {
                    Button(viewModel.saveButtonTitle) {
                        save()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle(viewModel.screenTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: Actions

    private func save() {
        guard viewModel.validate() else { return }
        let book = viewModel.makeBook()
        if viewModel.mode.isEditing {
            store.update(book)
        } else {
            store.add(book)
        }
        dismiss()
    }

    // MARK: Helpers

    @ViewBuilder
    private func errorRow(for field: BookFormViewModel.Field) -> some View {
        if let message = viewModel.errors[field] {
            Label(message, systemImage: "exclamationmark.circle.fill")
                .font(.caption)
                .foregroundStyle(Theme.Colors.danger)
        }
    }
}
