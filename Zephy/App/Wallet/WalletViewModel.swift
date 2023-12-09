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
    
    
    @Published var isConnected = true
    
    init() {
        Task { @MainActor in
            if let node = KeychainService.fetchNode() {
                let login = KeychainService.fetchNodeLogin()
                let password = KeychainService.fetchNodePassword()
                isConnected = await WalletService.connect(node: node,
                                                          login: login,
                                                          password: password)
                
                withAnimation {
                    zephyrBalance = WalletService.currentAssetBalance(asset: .zeph, full: true)
                    zephyrStableDollarsBalance = WalletService.currentAssetBalance(asset: .zsd, full: true)
                    zephyrReserveBalance = WalletService.currentAssetBalance(asset: .zrs, full: true)
                    
                    //print(WalletService.currentAssetBalance(asset: .zeph, full: false))
                    zephyrBalanceUnlocked = WalletService.currentAssetBalance(asset: .zeph, full: false)
                    zephyrStableDollarsBalanceUnlocked = WalletService.currentAssetBalance(asset: .zsd, full: false)
                    zephyrReserveBalanceUnlocked = WalletService.currentAssetBalance(asset: .zrs, full: false)
                }
            } else {
                isConnected = false
            }
        }
    }

    func sendZephyr(amount: Double) {
        // Implementation for sending Zephyr
    }

    func receiveZephyr(amount: Double) {
        // Implementation for receiving Zephyr
    }

    func swapZephyr(amount: Double,
                    currencyType: CurrencyType) {
        // Implementation for swapping Zephyr with other currencies
    }
}
