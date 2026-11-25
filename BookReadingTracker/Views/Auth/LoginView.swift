//
//  LoginView.swift
//  BookReadingTracker
//
//  Entry screen with three states:
//   • Face ID card (returning user)
//   • Login form (email + password)
//   • Register form (name, email, password, confirm password)
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject private var auth: AuthViewModel
    @Environment(\.scenePhase) private var scenePhase
    @FocusState private var focusedField: Field?

    private enum Field {
        case name, email, password, confirm
    }

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    hero

                    if auth.mode == .biometric {
                        biometricCard
                    } else {
                        formCard
                    }
                }
                .padding(Theme.Layout.screenPadding)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .task {
            if auth.mode == .biometric {
                await auth.authenticateWithBiometrics()
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active && auth.mode == .biometric {
                Task { await auth.authenticateWithBiometrics() }
            }
        }
    }

    // MARK: Hero

    private var hero: some View {
        VStack(spacing: 12) {
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color.white)
                .frame(width: 88, height: 88)
                .background(Color.white.opacity(0.18))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            Text("Book Reading Tracker")
                .font(Theme.Fonts.largeTitle)
                .foregroundStyle(Color.white)

            Text("Your personal reading shelf")
                .font(.subheadline)
                .foregroundStyle(Color.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .background(Theme.headerGradient)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    // MARK: Face ID card

    private var biometricCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "faceid")
                .font(.system(size: 48))
                .foregroundStyle(Theme.Colors.primary)

            Text(auth.rememberedName.map { "Welcome back, \($0)" } ?? "Welcome back")
                .font(Theme.Fonts.sectionTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text("Unlock with \(auth.biometryName) to open your reading shelf.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.Colors.textSecondary)

            Button {
                Task { await auth.authenticateWithBiometrics() }
            } label: {
                if auth.isAuthenticating {
                    ProgressView().tint(Color.white)
                } else {
                    Text("Unlock with \(auth.biometryName)")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(auth.isAuthenticating)

            Button("Use password instead") {
                auth.switchMode(.login)
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .cardStyle(padding: 22)
    }

    // MARK: Login / Register form

    private var modeBinding: Binding<Int> {
        Binding(
            get: { auth.mode == .register ? 1 : 0 },
            set: { auth.switchMode($0 == 1 ? .register : .login) }
        )
    }

    private var isRegistering: Bool {
        auth.mode == .register
    }

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Picker("Account", selection: modeBinding) {
                Text("Login").tag(0)
                Text("Register").tag(1)
            }
            .pickerStyle(.segmented)

            Text(isRegistering ? "Create your account" : "Welcome back")
                .font(Theme.Fonts.sectionTitle)
                .foregroundStyle(Theme.Colors.textPrimary)

            if let message = auth.infoMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            if isRegistering {
                fieldBlock(error: auth.nameError) {
                    TextField("Full name", text: $auth.name)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .email }
                }
            }

            fieldBlock(error: auth.emailError) {
                TextField("Email", text: $auth.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
            }

            fieldBlock(error: auth.passwordError) {
                SecureField(isRegistering ? "Password (6+ characters)" : "Password", text: $auth.password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(isRegistering ? .next : .go)
                    .onSubmit {
                        if isRegistering {
                            focusedField = .confirm
                        } else {
                            submit()
                        }
                    }
            }

            if isRegistering {
                fieldBlock(error: auth.confirmError) {
                    SecureField("Confirm password", text: $auth.confirmPassword)
                        .focused($focusedField, equals: .confirm)
                        .submitLabel(.go)
                        .onSubmit { submit() }
                }
            }

            Button(isRegistering ? "Create Account" : "Sign In") {
                submit()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 4)

            if !isRegistering && auth.hasRememberedUser {
                Button("Use \(auth.biometryName)") {
                    auth.switchMode(.biometric)
                    Task { await auth.authenticateWithBiometrics() }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(padding: 22)
    }

    // MARK: Helpers

    private func submit() {
        focusedField = nil
        if isRegistering {
            auth.register()
        } else {
            auth.login()
        }
    }

    private func fieldBlock<Content: View>(error: String?,
                                           @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            content()
                .inputFieldStyle()
            if let error = error {
                Label(error, systemImage: "exclamationmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(Theme.Colors.danger)
            }
        }
    }
}

// MARK: - Input field styling

private extension View {
    func inputFieldStyle() -> some View {
        self
            .padding(14)
            .background(Theme.Colors.lavender.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .foregroundStyle(Theme.Colors.textPrimary)
    }
}
