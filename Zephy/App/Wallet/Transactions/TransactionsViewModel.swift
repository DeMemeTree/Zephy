//
//  TransactionsViewModel.swift
//  Zephy
//
//
import Combine
import SwiftUI

final class TransactionsViewModel: ObservableObject {
    @Published var selectedAsset: Assets = .zeph 
    @Published var txs: [WalletService.TransactionInfoRowSwift] = []
    
    var filteredTransactions: [WalletService.TransactionInfoRowSwift] {
        txs.filter { transaction in
            guard let sourceType = transaction.source_type else { return false }
            return String(cString: sourceType) == selectedAsset.rawValue
        }
    }
    
    var disposeBag = Set<AnyCancellable>()
    
    func load() {
        WalletService.fetchAllTransactions()
            .backgroundToMain()
            .sink { [weak self] result in
                self?.txs = result
            }.store(in: &disposeBag)
    }
}
