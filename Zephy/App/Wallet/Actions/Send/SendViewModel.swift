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
    
    private var disposeBag = Set<AnyCancellable>()
    
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
        guard recipientAddress.lowercased().starts(with: "zephyr") || recipientAddress.lowercased().starts(with: "zeph") else { return }
        
        var assetType: String = ""
        if selectedAsset == Assets.zeph.uiDisplay {
            assetType = Assets.zeph.rawValue
        } else if selectedAsset == Assets.zsd.uiDisplay {
            assetType = Assets.zsd.rawValue
        } else if selectedAsset == Assets.zrs.uiDisplay {
            assetType = Assets.zrs.rawValue
        }
        
        // since we are just doing a send and not a swap assetType == destAssetType
        WalletService.transactionCreate(assetType: assetType,
                                        destAssetType: assetType,
                                        toAddress: recipientAddress,
                                        amount: amount,
                                        sendAll: availableAmount == amount)
            .backgroundToMain()
            .sink { result in
                if result {
                    router.changeRoot(to: .wallet)
                } else {
                    // TODO: Need to pop an error alert
                    print("Failed to send tx")
                }
            }
            .store(in: &disposeBag)
    }
}
