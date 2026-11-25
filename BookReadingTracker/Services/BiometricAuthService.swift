//
//  BiometricAuthService.swift
//  BookReadingTracker
//
//  Thin wrapper around LocalAuthentication (Face ID / Touch ID).
//

import LocalAuthentication

enum BiometricResult {
    case success
    /// The user cancelled or chose the fallback option.
    case fallback
    /// The system interrupted the prompt (for example the app went to the background).
    case interrupted
    /// Biometrics cannot be used (not enrolled, not available, locked out...).
    case unavailable(String)
    /// Authentication was attempted but did not succeed.
    case failed(String)
}

struct BiometricAuthService {

    /// "Face ID", "Touch ID" or a generic name, depending on the device.
    var biometryName: String {
        let context = LAContext()
        var error: NSError?
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        switch context.biometryType {
        case .faceID:  return "Face ID"
        case .touchID: return "Touch ID"
        default:       return "Biometrics"
        }
    }

    func authenticate(reason: String = "Unlock your reading shelf") async -> BiometricResult {
        let context = LAContext()
        context.localizedCancelTitle = "Use Email Login"

        var availabilityError: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &availabilityError) else {
            return .unavailable(availabilityError?.localizedDescription ?? "Biometrics are not available.")
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            return success ? .success : .failed("Authentication was not successful.")
        } catch let error as LAError {
            switch error.code {
            case .userCancel, .userFallback:
                return .fallback
            case .systemCancel, .appCancel, .notInteractive:
                return .interrupted
            default:
                return .failed(error.localizedDescription)
            }
        } catch {
            return .failed(error.localizedDescription)
        }
    }
}
