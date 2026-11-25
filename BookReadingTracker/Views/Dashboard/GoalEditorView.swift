//
//  GoalEditorView.swift
//  BookReadingTracker
//
//  Small sheet to change the number of books to finish this year.
//

import SwiftUI

struct GoalEditorView: View {

    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("How many books do you want to finish this year?")
                    .font(Theme.Fonts.sectionTitle)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text("\(viewModel.yearlyGoal)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.Colors.primary)

                Stepper("Books", value: $viewModel.yearlyGoal, in: 1...365)
                    .labelsHidden()

                Button("Done") {
                    dismiss()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Reading Goal")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
    }
}
