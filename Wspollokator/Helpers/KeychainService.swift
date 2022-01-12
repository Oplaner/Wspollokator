//
//  KeychainService.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 28.12.21.
//

import Foundation

class KeychainService {
    private static let securityItemLoginInformationLabel = "loginInformation"
    
    /// Adds login information to the keychain and returns the operation status.
    static func saveLoginInformation(email: String, password: String) -> Bool {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: securityItemLoginInformationLabel,
            kSecAttrAccount as String: email,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Returns login information stored in the keychain, or nil if it was not found.
    static func fetchLoginInformation() -> (email: String, password: String)? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: securityItemLoginInformationLabel,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess,
           let existingItem = item as? [String: Any],
           let email = existingItem[kSecAttrAccount as String] as? String,
           let passwordData = existingItem[kSecValueData as String] as? Data,
           let password = String(data: passwordData, encoding: .utf8) {
            return (email, password)
        } else {
            return nil
        }
    }
    
    /// Updates login information stored in the keychain.
    static func updateLoginInformation(email: String, password: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: securityItemLoginInformationLabel
        ]
        let attributes: [String: Any] = [
            kSecAttrAccount as String: email,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }
    
    /// Removes login information from the keychain.
    static func deleteLoginInformation() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: securityItemLoginInformationLabel
        ]
        SecItemDelete(query as CFDictionary)
    }
}
