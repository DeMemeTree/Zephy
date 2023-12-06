//
//  WalletViewModel.swift
//  Zephy
//
//
import Foundation

class WalletViewModel: ObservableObject {
    enum CurrencyType {
        case zephyr
        case stableDollars
        case reserve
    }
    
    @Published var zephyrBalance: UInt64 = WalletService.currentZephBalance()
    @Published var zephyrStableDollarsBalance: Double = 4.20
    @Published var zephyrReserveBalance: Double = 6942
    @Published var isConnected = true
    
    init() {
        Task { @MainActor in
            if let node = KeychainService.fetchNode() {
                let login = KeychainService.fetchNodeLogin()
                let password = KeychainService.fetchNodePassword()
                isConnected = await WalletService.connect(node: node,
                                                          login: login,
                                                          password: password)
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
