//
//  DashboardViewModel.swift
//  BookReadingTracker
//
//  Greeting text and the yearly reading goal (saved in UserDefaults).
//

import Foundation

final class DashboardViewModel: ObservableObject {

    private static let goalKey = "yearlyBookGoal"
    static let defaultGoal = 12

    private let defaults: UserDefaults

    /// Number of books the reader wants to finish this year.
    @Published var yearlyGoal: Int {
        didSet {
            defaults.set(yearlyGoal, forKey: Self.goalKey)
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let saved = defaults.integer(forKey: Self.goalKey)
        yearlyGoal = saved > 0 ? saved : Self.defaultGoal
    }

    /// "Good morning / afternoon / evening" based on the current time.
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning"
        case 12..<17: return "Good afternoon"
        default:      return "Good evening"
        }
    }

    var dateText: String {
        Date().formatted(.dateTime.weekday(.wide).day().month(.wide))
    }

    /// Goal progress 0...1 based on finished books.
    func goalProgress(finishedBooks: Int) -> Double {
        guard yearlyGoal > 0 else { return 0 }
        return min(Double(finishedBooks) / Double(yearlyGoal), 1)
    }

    func booksToGo(finishedBooks: Int) -> Int {
        max(yearlyGoal - finishedBooks, 0)
    }
}
