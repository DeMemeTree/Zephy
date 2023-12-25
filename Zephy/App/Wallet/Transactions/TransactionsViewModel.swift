//
//  TransactionsViewModel.swift
//  Zephy
//
//
import Combine
import SwiftUI

struct TransactionUIWrapper: Identifiable {
    let id = UUID()
    let tx: WalletService.TransactionInfoRowSwift
}

final class TransactionsViewModel: ObservableObject {
    @Published var selectedAsset: Assets = .zeph 
    @Published var filteredTransactions: [TransactionUIWrapper] = []
    
    func load() {
        let result = WalletService.fetchAllTransactions(ofType: selectedAsset.rawValue)
        self.filteredTransactions = result.map({ TransactionUIWrapper(tx: $0) })
    }
}
