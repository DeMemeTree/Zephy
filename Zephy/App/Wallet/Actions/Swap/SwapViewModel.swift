//
//  SwapViewModel.swift
//  Zephy
//
//
import SwiftUI
import Combine

class SwapViewModel: ObservableObject {
    @Published var fromAsset: String = Assets.zeph.rawValue
    @Published var toAsset: String = Assets.zsd.rawValue
    
    @Published var availableAmount: String = "0.6042"
    @Published var fromAmount: String = ""
    @Published var toAmount: String = ""
    @Published var recipientAddress: String = "All Addresses (Default)"
    @Published var conversionRate: String = "1 ZSD : 0.023984 ZEPH"
    @Published var unlockTime: String = "~20m"
    
    var assets: [String] = [Assets.zeph.rawValue,
                             Assets.zsd.rawValue,
                             Assets.zrs.rawValue]
    
    let addresses = ["All Addresses (Default)", "Address 1", "Address 2"] // Example addresses

    // Simulate a swap calculation
    func calculateSwap() {
        // Perform the calculation based on the assets and amounts
        // Update `toAmount` with the result of the calculation
        // This is where you would integrate with your swapping logic/API
    }

    func performSwapPreview() {
        // Implement the swap preview functionality
        // This might involve validation and then showing a confirmation dialog
    }
    
    func useMaxAmount() {
        fromAmount = availableAmount
    }
}
