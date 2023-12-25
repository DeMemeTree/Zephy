//
//  FileService.swift
//  Zephy
//
//

import Foundation

struct FileService {
    static func pathForWalletDir(name: String) throws -> URL {
        let fileManager = FileManager.default
        let root = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

        let walletsDir = root.appendingPathComponent("wallets")
        let walletDir = walletsDir.appendingPathComponent("zephyr/\(name)")

        if !fileManager.fileExists(atPath: walletDir.path) {
            try fileManager.createDirectory(at: walletDir, withIntermediateDirectories: true)
            let protectionValue = FileProtectionType.completeUntilFirstUserAuthentication
            try fileManager.setAttributes([.protectionKey: protectionValue], ofItemAtPath: walletDir.path)
        }

        return walletDir
    }

    static func pathForWallet(name: String) throws -> URL {
        let walletDir = try pathForWalletDir(name: name)
        return walletDir.appendingPathComponent(name)
    }
}
