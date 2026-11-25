//
//  AccountStorageService.swift
//  BookReadingTracker
//
//  Saves registered accounts and remembers who signed in last (for Face ID unlock).
//

import Foundation

struct AccountStorageService {

    private let defaults: UserDefaults
    private let accountsKey = "registeredAccounts"
    private let lastUserKey = "lastSignedInAccountID"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadAccounts() -> [UserAccount] {
        guard let data = defaults.data(forKey: accountsKey) else { return [] }
        do {
            return try JSONDecoder().decode([UserAccount].self, from: data)
        } catch {
            print("AccountStorageService: failed to load accounts – \(error.localizedDescription)")
            return []
        }
    }

    func saveAccounts(_ accounts: [UserAccount]) {
        do {
            let data = try JSONEncoder().encode(accounts)
            defaults.set(data, forKey: accountsKey)
        } catch {
            print("AccountStorageService: failed to save accounts – \(error.localizedDescription)")
        }
    }

    /// The account that Face ID will unlock.
    var lastSignedInID: UUID? {
        get {
            defaults.string(forKey: lastUserKey).flatMap { UUID(uuidString: $0) }
        }
        nonmutating set {
            defaults.set(newValue?.uuidString, forKey: lastUserKey)
        }
    }
}
