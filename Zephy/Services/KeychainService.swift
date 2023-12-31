//
//  KeychainService.swift
//  Zephy
//
//
import Foundation
import Security

class KeychainService {
    private static let seedKey = "seedKey"
    private static let passwordKey = "passwordKey"
    private static let nodeURLKey = "nodeURLKey"
    
    static func save(node: String,
                     login: String?,
                     password: String?) {
        UserDefaults.standard.setValue(node, forKey: nodeURLKey)
        UserDefaults.standard.setValue(login, forKey: nodeURLKey + "login")
        UserDefaults.standard.setValue(password, forKey: nodeURLKey + "password")
    }
    
    static func fetchNode() -> String? {
        return UserDefaults.standard.string(forKey: nodeURLKey)
    }
    
    static func fetchNodeLogin() -> String? {
        return UserDefaults.standard.string(forKey: nodeURLKey + "login")
    }
    
    static func fetchNodePassword() -> String? {
        return UserDefaults.standard.string(forKey:  nodeURLKey + "password")
    }
    
    static func save(seed: String) -> Bool {
        return KeychainService.store(key: seedKey, value: seed)
    }
    
    static func fetchSeed() -> String? {
        return KeychainService.retrieve(key: seedKey)
    }
    
    static func password() -> String? {
        return KeychainService.retrieve(key: passwordKey)
    }
    
    static func save(password: String) -> Bool {
        return KeychainService.store(key: passwordKey, value: password)
    }
    
    private static func store(key: String, value: String) -> Bool {
        guard let valueData = value.data(using: .utf8) else { return false }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData
        ]
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    private static func retrieve(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess else { return nil }
        guard let data = item as? Data else { return nil }

        return String(data: data, encoding: .utf8)
    }
}
