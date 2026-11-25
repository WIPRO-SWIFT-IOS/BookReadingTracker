//
//  Validators.swift
//  BookReadingTracker
//
//  Small, reusable input-validation helpers.
//

import Foundation

extension String {
    /// The string without leading/trailing whitespace and newlines.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum Validators {

    /// True when the string is empty or only whitespace.
    static func isBlank(_ value: String) -> Bool {
        value.trimmed.isEmpty
    }

    /// Basic e-mail format check (name@domain.tld).
    static func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email.trimmed)
    }
}
