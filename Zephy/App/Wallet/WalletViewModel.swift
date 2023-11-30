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
    
    @Published var zephyrBalance: Double = 42
    @Published var zephyrStableDollarsBalance: Double = 4.20
    @Published var zephyrReserveBalance: Double = 6942

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
