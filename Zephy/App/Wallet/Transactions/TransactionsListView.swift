//
//  TransactionsView.swift
//  Zephy
//
//
import Combine
import SwiftUI

struct TransactionsListView: View {
    @StateObject var viewModel = TransactionsViewModel()
    
    @State var isSynchronized = false
    
    var body: some View {
        ScrollView {
            if isSynchronized {
                syncView()
            } else {
                Text("Transaction history will display once fully synced with node")
                    .padding()
            }
        }
        .padding(.top)
        .onReceive(SyncHeader.syncRx) { newData in
            guard newData.currentBlock != 0 else { return }
            load()
            withAnimation {
                isSynchronized = newData.synchronized
            }
        }
    }
    
    private func syncView() -> some View {
        VStack {
            Picker("Select Asset", selection: $viewModel.selectedAsset) {
                Text(Assets.zeph.uiDisplay).tag(Assets.zeph)
                Text(Assets.zrs.uiDisplay).tag(Assets.zrs)
                Text(Assets.zsd.uiDisplay).tag(Assets.zsd)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onChange(of: viewModel.selectedAsset) { _ in
                load()
            }
            
            Text("Showing \(viewModel.filteredTransactions.count) of the most recent transactions")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.vertical, 3)

            if viewModel.filteredTransactions.isEmpty {
                Text("No transactions to display.")
                    .padding()
            } else {
                ForEach(viewModel.filteredTransactions) { data in
                    TransactionView(transaction: data.tx)
                        .id(data.id)
                }
            }
            
            Rectangle()
                .frame(height: 50)
                .foregroundColor(.clear)
        }
    }
    
    private func load() {
        viewModel.load()
    }
}
