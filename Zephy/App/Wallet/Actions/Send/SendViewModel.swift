//
//  SendViewModel.swift
//  Zephy
//
//
import Foundation
import Combine

class SendViewModel: ObservableObject {
    @Published var selectedAsset: String = Assets.zeph.uiDisplay
    
    @Published var recipientAddress: String = ""
    @Published var amount: String = ""
    @Published var availableAmount: String = ""
    
    @Published var zephyrBalanceUnlocked: UInt64 = WalletService.currentAssetBalance(asset: .zeph, full: false)
    @Published var zephyrStableDollarsBalanceUnlocked: UInt64 = WalletService.currentAssetBalance(asset: .zsd, full: false)
    @Published var zephyrReserveBalanceUnlocked: UInt64 = WalletService.currentAssetBalance(asset: .zrs, full: false)
    
    var assets: [String] = [Assets.zeph.uiDisplay,
                            Assets.zsd.uiDisplay,
                            Assets.zrs.uiDisplay]
    
    func updateAvailableAmount() {
        if selectedAsset == Assets.zeph.uiDisplay {
            availableAmount = String(zephyrBalanceUnlocked.formatHuman())
        } else if selectedAsset == Assets.zsd.uiDisplay {
            availableAmount = String(zephyrStableDollarsBalanceUnlocked.formatHuman())
        } else if selectedAsset == Assets.zrs.uiDisplay {
            availableAmount = String(zephyrReserveBalanceUnlocked.formatHuman())
        }
    }

    func useMaxAmount() {
        if selectedAsset == Assets.zeph.uiDisplay {
            amount = String(zephyrBalanceUnlocked.formatHuman())
        } else if selectedAsset == Assets.zsd.uiDisplay {
            amount = String(zephyrStableDollarsBalanceUnlocked.formatHuman())
        } else if selectedAsset == Assets.zrs.uiDisplay {
            amount = String(zephyrReserveBalanceUnlocked.formatHuman())
        }
    }
    
    func makeTransaction(router: Router) {
        // Implement the preview logic here
        print("Previewing transfer of \(amount) \(selectedAsset) to \(recipientAddress)")
        
        router.changeRoot(to: .wallet)
    }
}
