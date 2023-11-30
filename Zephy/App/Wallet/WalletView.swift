//
//  WalletView.swift
//  Zephy
//
//

import SwiftUI

struct WalletView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = WalletViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Zephyr Protocol Wallet")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("The private untraceable stablecoin")
                .font(.headline)
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    ZStack {
                        HStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                        Text("Wallet Balances")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    balanceText("Zeph: \(viewModel.zephyrBalance)", type: .zephyr)
                    balanceText("ZSD: \(viewModel.zephyrStableDollarsBalance)", type: .stableDollars)
                    balanceText("ZRS: \(viewModel.zephyrReserveBalance)", type: .reserve)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .padding()
                
                walletActions()
            }
            .padding()
            
            Divider()
                .background(Color.white)
            
            StatsView()
        }
    }
    
    private func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .cornerRadius(10)
        }
    }
    
    private func balanceText(_ text: String, type: WalletViewModel.CurrencyType) -> some View {
        HStack {
            switch type {
            case .reserve:
                Image("zrs")
                    .resizable()
                    .frame(width: 40, height: 40)
            case .stableDollars:
                Image("zsd")
                    .resizable()
                    .frame(width: 40, height: 40)
            case .zephyr:
                Image("zeph")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Text(text)
                .font(.body)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func walletActions() -> some View {
        HStack {
            actionButton(title: "Send",
                         action: {
                router.changeRoot(to: .send)
                //viewModel.sendZephyr(amount: 100)
            })
            Spacer()
            actionButton(title: "Receive",
                         action: {
                router.changeRoot(to: .receive)
                //viewModel.receiveZephyr(amount: 100)
            })
            Spacer()
            actionButton(title: "Swap",
                         action: {
                router.changeRoot(to: .swap)
               // viewModel.swapZephyr(amount: 100, currencyType: .reserve)
            })
        }
        .padding(.horizontal)
    }
}
