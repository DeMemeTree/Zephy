//
//  StatsViewModel.swift
//  Zephy
//
//
import SwiftUI

final class StatsViewModel: ObservableObject {
    @Published var pricingRecord: WalletService.PricingRecord?
    private let pricingRecordKey = "pricingRecord"
    private let lastFetchedHeightKey = "lastFetchedHeight"

    init() {
        loadCachedPricingRecord()
    }

    func load() async {
        let height = await WalletService.getCurrentBlockHeight()
        guard height != cachedHeight() else { return }
        
        let record = await WalletService.getPricingRecordFromBlock(height: height)
        cachePricingRecord(record, height: height)
        DispatchQueue.main.async {
            self.pricingRecord = record
        }
    }

    private func loadCachedPricingRecord() {
        if let data = UserDefaults.standard.data(forKey: pricingRecordKey),
           let savedRecord = try? JSONDecoder().decode(WalletService.PricingRecord.self, from: data) {
            pricingRecord = savedRecord
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
