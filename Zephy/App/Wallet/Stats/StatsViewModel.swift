//
//  StatsViewModel.swift
//  Zephy
//
//
import SwiftUI

final class StatsViewModel: ObservableObject {
    @Published var pricingRecord: WalletService.PricingRecord?
    @Published var notConnected: Bool = false
    
    private let pricingRecordKey = "pricingRecord"
    private let lastFetchedHeightKey = "lastFetchedHeight"

    init() {
        loadCachedPricingRecord()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            if self.pricingRecord == nil {
                self.notConnected = true
            }
        })
    }

    @MainActor
    func load() async {
        let height = await WalletService.getCurrentBlockHeight()
        guard height != cachedHeight() else {
            loadCachedPricingRecord()
            return
        }
        
        let record = await WalletService.getPricingRecordFromBlock(height: height)
        if let record = record {
            WalletView.pricingBlock.send(record)
        }
        cachePricingRecord(record, height: height)
        
        notConnected = false
        pricingRecord = record
    }

    private func loadCachedPricingRecord() {
        if let data = UserDefaults.standard.data(forKey: pricingRecordKey),
           let savedRecord = try? JSONDecoder().decode(WalletService.PricingRecord.self, from: data) {
            pricingRecord = savedRecord
            WalletView.pricingBlock.send(savedRecord)
        }
    }

    private func cachePricingRecord(_ record: WalletService.PricingRecord?, height: UInt64) {
        if let record = record,
           let data = try? JSONEncoder().encode(record) {
            UserDefaults.standard.set(data, forKey: pricingRecordKey)
            UserDefaults.standard.set(height, forKey: lastFetchedHeightKey)
        }
    }
    
    private func cachedHeight() -> Int {
        UserDefaults.standard.integer(forKey: lastFetchedHeightKey)
    }
}
