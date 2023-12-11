//
//  SwapViewModel.swift
//  Zephy
//
//
import SwiftUI
import Combine

class SwapViewModel: ObservableObject {
    @Published var fromAsset: String = Assets.zeph.uiDisplay
    @Published var toAsset: String = Assets.zsd.uiDisplay
    
    @Published var availableAmount: String = "0"
    @Published var fromAmount: String = ""
    @Published var error = ""
    
    @Published var zephyrBalanceUnlocked: UInt64 = WalletService.currentAssetBalance(asset: .zeph, full: false)
    @Published var zephyrStableDollarsBalanceUnlocked: UInt64 = WalletService.currentAssetBalance(asset: .zsd, full: false)
    @Published var zephyrReserveBalanceUnlocked: UInt64 = WalletService.currentAssetBalance(asset: .zrs, full: false)
    
    var assets: [String] = [Assets.zeph.uiDisplay,
                             Assets.zsd.uiDisplay,
                             Assets.zrs.uiDisplay]
    
    private var disposeBag = Set<AnyCancellable>()
    
    init() {
        updateAvailableAmount()
    }
    
    func calculateSwap() {
        // TODO:
    }
    
    func recalcSwapAssets() {
        if fromAsset == toAsset {
            if fromAsset == Assets.zeph.uiDisplay {
                toAsset = Assets.zsd.uiDisplay
            } else if fromAsset == Assets.zsd.uiDisplay {
                toAsset = Assets.zeph.uiDisplay
            } else if fromAsset == Assets.zrs.uiDisplay {
                toAsset = Assets.zeph.uiDisplay
            }
        }
        updateAvailableAmount()
    }

    func updateAvailableAmount() {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        formatter.numberStyle = .decimal

        var amount: Double = 0.0

        if fromAsset == Assets.zeph.uiDisplay {
            amount = Double(zephyrBalanceUnlocked.formatHuman()) ?? 0
        } else if fromAsset == Assets.zsd.uiDisplay {
            amount = Double(zephyrStableDollarsBalanceUnlocked.formatHuman()) ?? 0
        } else if fromAsset == Assets.zrs.uiDisplay {
            amount = Double(zephyrReserveBalanceUnlocked.formatHuman()) ?? 0
        }

        if let formattedString = formatter.string(from: NSNumber(value: amount)) {
            availableAmount = formattedString
        } else {
            availableAmount = String(amount)
        }
        fromAmount = ""
    }

    func useMaxAmount() {
        fromAmount = availableAmount
    }
    
    func makeSwap(router: Router) {
        guard let recipientAddress = WalletService.allAddresses().first?.1,
               recipientAddress.lowercased().starts(with: "zephyr") || recipientAddress.lowercased().starts(with: "zeph") else { 
            error = "Must have an address to swap to"
            return }
        
        var fromAssetType: String = ""
        var toAssetType: String = ""
        if fromAsset == Assets.zeph.uiDisplay {
            fromAssetType = Assets.zeph.rawValue
        } else if fromAsset == Assets.zsd.uiDisplay {
            fromAssetType = Assets.zsd.rawValue
        } else if fromAsset == Assets.zrs.uiDisplay {
            fromAssetType = Assets.zrs.rawValue
        }
        
        if toAsset == Assets.zeph.uiDisplay {
            toAssetType = Assets.zeph.rawValue
        } else if toAsset == Assets.zsd.uiDisplay {
            toAssetType = Assets.zsd.rawValue
        } else if toAsset == Assets.zrs.uiDisplay {
            toAssetType = Assets.zrs.rawValue
        }
        
        guard fromAssetType != toAssetType else { 
            error = "Assets types cant be equal"
            return }
        
        error = ""
        
        WalletService.transactionCreate(assetType: fromAssetType,
                                        destAssetType: toAssetType,
                                        toAddress: recipientAddress,
                                        amount: fromAmount)
            .backgroundToMain()
            .sink { [weak self] result in
                if result {
                    router.changeRoot(to: .wallet)
                } else {
                    if toAssetType == Assets.zrs.rawValue {
                        self?.error = "Hm double check the ratios allow swapping."
                    } else {
                        self?.error = "Failed to swap. Try again with a lesser amount. Im still working on coding the math to take out the fee"
                    }
                }
            }
            .store(in: &disposeBag)
    }
}
