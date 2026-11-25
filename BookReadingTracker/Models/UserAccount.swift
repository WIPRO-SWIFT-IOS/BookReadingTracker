//
//  UserAccount.swift
//  BookReadingTracker
//
//  A locally registered reader. The password is never stored – only a salted hash.
//

import Foundation

struct UserAccount: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var email: String          // stored lower-cased
    var salt: String
    var passwordHash: String

    /// Used to give every account its own shelf file.
    var shelfID: String {
        id.uuidString
    }
}
