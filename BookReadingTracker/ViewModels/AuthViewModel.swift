//
//  AuthViewModel.swift
//  BookReadingTracker
//
//  Controls authentication:
//   • Face ID unlocks the last signed-in account.
//   • If Face ID is unavailable or fails, the user logs in with email + password.
//   • New users register a local account (name, email, password).
//  Accounts live only on this device.
//

import Foundation

enum AuthMode {
    case biometric
    case login
    case register
}

final class AuthViewModel: ObservableObject {

    // MARK: State

    @Published private(set) var isAuthenticated = false
    @Published private(set) var isAuthenticating = false
    @Published private(set) var currentUser: UserAccount?
    @Published var mode: AuthMode

    // Form fields
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    // Validation messages
    @Published private(set) var nameError: String?
    @Published private(set) var emailError: String?
    @Published private(set) var passwordError: String?
    @Published private(set) var confirmError: String?
    @Published private(set) var infoMessage: String?

    // MARK: Dependencies

    private let biometricService: BiometricAuthService
    private let accountStorage: AccountStorageService
    private let bookStore: BookStore
    private var accounts: [UserAccount]

    init(bookStore: BookStore,
         biometricService: BiometricAuthService = BiometricAuthService(),
         accountStorage: AccountStorageService = AccountStorageService()) {
        self.bookStore = bookStore
        self.biometricService = biometricService
        self.accountStorage = accountStorage

        let loaded = accountStorage.loadAccounts()
        self.accounts = loaded

        let initialMode: AuthMode
        if let lastID = accountStorage.lastSignedInID, loaded.contains(where: { $0.id == lastID }) {
            initialMode = .biometric
        } else if loaded.isEmpty {
            initialMode = .register
        } else {
            initialMode = .login
        }
        self.mode = initialMode
    }

    // MARK: Derived

    var biometryName: String {
        biometricService.biometryName
    }

    /// The account Face ID would unlock.
    private var rememberedAccount: UserAccount? {
        guard let id = accountStorage.lastSignedInID else { return nil }
        return accounts.first { $0.id == id }
    }

    var hasRememberedUser: Bool {
        rememberedAccount != nil
    }

    var rememberedName: String? {
        rememberedAccount?.name
    }

    // MARK: Mode switching

    func switchMode(_ newMode: AuthMode) {
        clearErrors()
        infoMessage = nil
        mode = newMode
    }

    // MARK: Face ID

    @MainActor
    func authenticateWithBiometrics() async {
        guard !isAuthenticating, !isAuthenticated else { return }

        guard let account = rememberedAccount else {
            mode = accounts.isEmpty ? .register : .login
            return
        }

        isAuthenticating = true
        defer { isAuthenticating = false }

        switch await biometricService.authenticate() {
        case .success:
            signIn(account)
        case .interrupted:
            break
        case .fallback:
            email = account.email
            mode = .login
        case .unavailable(let message):
            email = account.email
            infoMessage = "\(biometryName) isn't available (\(message)) Please sign in with your password."
            mode = .login
        case .failed(let message):
            email = account.email
            infoMessage = "\(message) Please sign in with your password."
            mode = .login
        }
    }

    // MARK: Login

    func login() {
        clearErrors()

        if Validators.isBlank(email) {
            emailError = "Email is required."
        } else if !Validators.isValidEmail(email) {
            emailError = "Enter a valid email address."
        }
        if password.isEmpty {
            passwordError = "Password is required."
        }
        guard emailError == nil, passwordError == nil else { return }

        let normalizedEmail = email.trimmed.lowercased()
        guard let account = accounts.first(where: { $0.email == normalizedEmail }),
              PasswordHasher.hash(password, salt: account.salt) == account.passwordHash else {
            passwordError = accounts.isEmpty
                ? "No account found. Please register first."
                : "Incorrect email or password."
            return
        }
        signIn(account)
    }

    // MARK: Register

    func register() {
        clearErrors()

        if Validators.isBlank(name) {
            nameError = "Name is required."
        }
        if Validators.isBlank(email) {
            emailError = "Email is required."
        } else if !Validators.isValidEmail(email) {
            emailError = "Enter a valid email address."
        }
        if password.isEmpty {
            passwordError = "Password is required."
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters."
        }
        if confirmPassword.isEmpty {
            confirmError = "Please confirm your password."
        } else if confirmPassword != password {
            confirmError = "Passwords do not match."
        }

        let normalizedEmail = email.trimmed.lowercased()
        if emailError == nil, accounts.contains(where: { $0.email == normalizedEmail }) {
            emailError = "An account with this email already exists."
        }

        guard nameError == nil, emailError == nil, passwordError == nil, confirmError == nil else { return }

        let salt = PasswordHasher.makeSalt()
        let account = UserAccount(
            name: name.trimmed,
            email: normalizedEmail,
            salt: salt,
            passwordHash: PasswordHasher.hash(password, salt: salt)
        )
        accounts.append(account)
        accountStorage.saveAccounts(accounts)
        signIn(account)
    }

    // MARK: Lock / sign out

    /// Locks the app. Face ID (or password) is needed to open the shelf again.
    func lock() {
        bookStore.closeShelf()
        isAuthenticated = false
        currentUser = nil
        resetForm()
        mode = hasRememberedUser ? .biometric : (accounts.isEmpty ? .register : .login)
    }

    /// Signs out completely: Face ID no longer unlocks this account until the next password login.
    func signOut() {
        accountStorage.lastSignedInID = nil
        lock()
    }

    // MARK: Helpers

    private func signIn(_ account: UserAccount) {
        accountStorage.lastSignedInID = account.id
        bookStore.openShelf(for: account.shelfID)
        currentUser = account
        resetForm()
        isAuthenticated = true
    }

    private func resetForm() {
        name = ""
        email = ""
        password = ""
        confirmPassword = ""
        infoMessage = nil
        clearErrors()
    }

    private func clearErrors() {
        nameError = nil
        emailError = nil
        passwordError = nil
        confirmError = nil
    }
}
