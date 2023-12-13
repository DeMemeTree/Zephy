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
                    Text(Assets.zeph.uiDisplay).tag(Assets.zeph)
                    Text(Assets.zrs.uiDisplay).tag(Assets.zrs)
                    Text(Assets.zsd.uiDisplay).tag(Assets.zsd)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Text("Showing \(viewModel.filteredTransactions.count) of the most recent transactions")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.vertical, 3)

                if viewModel.filteredTransactions.isEmpty {
                    Text("No transactions to display.")
                        .padding()
                } else {
                    ForEach(viewModel.filteredTransactions, id: \.hash) { transaction in
                        TransactionView(transaction: transaction)
                            .id(transaction.hash)
                    }
                }
                
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.clear)
            }
            .id(viewModel.filteredTransactions.count)
        }
        .padding(.top)
        .onAppear {
            load()
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
