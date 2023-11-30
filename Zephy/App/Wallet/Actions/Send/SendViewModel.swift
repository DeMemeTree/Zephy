//
//  SendViewModel.swift
//  Zephy
//
//
import Foundation
import Combine

class SendViewModel: ObservableObject {
    @Published var selectedAsset: String = Assets.zeph.rawValue
    @Published var recipientAddress: String = ""
    @Published var amount: String = ""
    @Published var availableAmount: String = "0.6042"
    
    var assets: [String] = [Assets.zeph.rawValue,
                            Assets.zsd.rawValue,
                            Assets.zrs.rawValue]

    func useMaxAmount() {
        amount = availableAmount
    }
    
    func makeTransaction(router: Router) {
        // Implement the preview logic here
        print("Previewing transfer of \(amount) \(selectedAsset) to \(recipientAddress)")
        
        router.changeRoot(to: .wallet)
    }
}
