//
//  TransactionsView.swift
//  Zephy
//
//
import SwiftUI

struct TransactionsListView: View {
    @StateObject var viewModel = TransactionsViewModel()

    var body: some View {
        ScrollView {
            VStack {
                Picker("Select Asset", selection: $viewModel.selectedAsset) {
                    Text(Assets.zeph.rawValue).tag(Assets.zeph)
                    Text(Assets.zrs.rawValue).tag(Assets.zrs)
                    Text(Assets.zsd.rawValue).tag(Assets.zsd)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top)
                .padding(.horizontal)
                
                if viewModel.filteredTransactions.count > 0 {
                    Text("Showing \(viewModel.filteredTransactions.count) of the most recent transactions")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                if viewModel.filteredTransactions.isEmpty {
                    Text("No transactions to display.")
                        .padding()
                } else {
                    ForEach(viewModel.filteredTransactions, id: \.hash) { transaction in
                        TransactionView(transaction: transaction)
                    }
                }
            }
        }
        .onChange(of: viewModel.selectedAsset) { _ in
            load()
        }
        .onReceive(SyncHeader.syncRx) { newData in
            guard newData.currentBlock != 0 else { return }
            load()
        }
    }
    
    private func load() {
        withAnimation {
            viewModel.load()
        }
    }
}
