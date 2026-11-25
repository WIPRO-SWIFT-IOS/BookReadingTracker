//
//  PasswordHasher.swift
//  BookReadingTracker
//
//  Salted, repeated SHA-256 hashing so plain passwords are never saved on the device.
//

import CryptoKit
import Foundation

enum PasswordHasher {

    private static let rounds = 10_000

    static func makeSalt() -> String {
        UUID().uuidString
    }

    static func hash(_ password: String, salt: String) -> String {
        var data = Data((salt + password).utf8)
        for _ in 0..<rounds {
            data = Data(SHA256.hash(data: data))
        }
        return data.map { String(format: "%02x", $0) }.joined()
    }
}
