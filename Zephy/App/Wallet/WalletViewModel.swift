//
//  WalletViewModel.swift
//  Zephy
//
//
import SwiftUI

class WalletViewModel: ObservableObject {
    enum CurrencyType {
        case zephyr
        case stableDollars
        case reserve
    }
    
    @Published var zephyrBalance: UInt64 = WalletService.currentAssetBalance(asset: .zeph, full: true)
    @Published var zephyrStableDollarsBalance: UInt64 = WalletService.currentAssetBalance(asset: .zsd, full: true)
    @Published var zephyrReserveBalance: UInt64 = WalletService.currentAssetBalance(asset: .zrs, full: true)
    
    @Published var zephyrBalanceUnlocked: UInt64 = WalletService.currentAssetBalance(asset: .zeph, full: false)
    @Published var zephyrStableDollarsBalanceUnlocked: UInt64 = WalletService.currentAssetBalance(asset: .zsd, full: false)
    @Published var zephyrReserveBalanceUnlocked: UInt64 = WalletService.currentAssetBalance(asset: .zrs, full: false)
    
    
    init() {
        Task { @MainActor in
            if let node = KeychainService.fetchNode() {
                let login = KeychainService.fetchNodeLogin()
                let password = KeychainService.fetchNodePassword()
                SyncHeader.isConnected.send(await WalletService.connect(node: node,
                                                                        login: login,
                                                                        password: password))
                
                loadB()
            }
        }
    }
    
    func loadB() {
        DispatchQueue.main.async {
            withAnimation {
                self.zephyrBalance = WalletService.currentAssetBalance(asset: .zeph, full: true)
                self.zephyrStableDollarsBalance = WalletService.currentAssetBalance(asset: .zsd, full: true)
                self.zephyrReserveBalance = WalletService.currentAssetBalance(asset: .zrs, full: true)
                
                self.zephyrBalanceUnlocked = WalletService.currentAssetBalance(asset: .zeph, full: false)
                self.zephyrStableDollarsBalanceUnlocked = WalletService.currentAssetBalance(asset: .zsd, full: false)
                self.zephyrReserveBalanceUnlocked = WalletService.currentAssetBalance(asset: .zrs, full: false)
            }
        }
    }
}
