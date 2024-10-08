//
//  StatsView.swift
//  Zephy
//
//

import SwiftUI

struct StatsView: View {
    @StateObject var viewModel = StatsViewModel()
    @State var notConnectedToANode = false
    
    var body: some View {
        VStack {
            if let record = viewModel.pricingRecord {
                pricing(record: record)
            } else {
                ProgressView()
                    .padding(.top)
            }
            Spacer()
        }
        .sheet(isPresented: $viewModel.notConnected, content: {
            NodesView()
        })
        .onReceive(SyncHeader.syncRx) { newData in
            guard newData.currentBlock != 0 else { return }
            Task {
                await viewModel.load()
            }
        }
        .task {
            await viewModel.load()
        }
    }
    
    private func pricing(record: WalletService.PricingRecord) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                statCardView(title: "Zephyr Price",
                             spot: String(format: "%.2f%@", record.spot, ""),
                             ma: String(format: "%.2f%@", record.movingAverage, ""),
                             dollars: true)

                statCardView(title: "Zephyr Stable Dollars",
                             spot: String(format: "%.5f%@", record.stable, ""),
                             ma: String(format: "%.5f%@", record.stableMa, ""))

                statCardView(title: "Zephyr Reserve Shares",
                             spot: String(format: "%.5f%@", record.reserve, ""),
                             ma: String(format: "%.5f%@", record.reserveMa, ""))
            }
            .padding(.top, 10)
        }
    }
    
    func statCardView(title: String,
                      spot: String,
                      ma: String,
                      dollars: Bool = false) -> some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            HStack {
                VStack {
                    Text("Spot")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack {
                        Text(dollars ? "$\(spot)" : spot)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        if dollars == false {
                            Text("ZEPH")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                Spacer()
                
                VStack {
                    Text("Moving Average")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack {
                        Text(dollars ? "$\(ma)" : ma)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        if dollars == false {
                            Text("ZEPH")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding()
        //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
        .padding(.vertical, 5)
        .padding(.horizontal, 15)
    }
    
    func detailView(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
                .foregroundColor(.white)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
