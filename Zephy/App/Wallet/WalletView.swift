//
//  WalletView.swift
//  Zephy
//
//
import Combine
import SwiftUI

struct WalletView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var timeKeeper: TimeKeeper
    
    @StateObject var viewModel = WalletViewModel()
    @State var spotBalance: String? = nil
    @State private var selectedTab = 0
    
    static let pricingBlock = PassthroughSubject<WalletService.PricingRecord, Never>()
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Zephyr Protocol Wallet")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("The private untraceable stablecoin")
                .font(.subheadline)
            
            VStack(spacing: 0) {
                balanceView()
                
                VStack(spacing: 8) {
                    SyncHeader()
                    balances()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.8), radius: 5, x: 0, y: 2)
                
                walletActions()
                    .padding(.top, 20)
            }
            .padding()
            
            Divider()
                .background(Color.white)
            
            Text("swipe to change view")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top)
            
            bottomView()
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(WalletView.pricingBlock, perform: { record in
            var totalBalance: Double = 0
            totalBalance += (Double(viewModel.zephyrBalance.formatHuman()) ?? 0)
            totalBalance += (Double(viewModel.zephyrStableDollarsBalance.formatHuman()) ?? 0) * record.stable
            totalBalance += (Double(viewModel.zephyrReserveBalance.formatHuman()) ?? 0) * record.reserve
            let truncatedValue = (totalBalance * record.spot * 100) / 100
            withAnimation {
                spotBalance = String(format: "%.2f", truncatedValue)
            }
            
        })
        .onReceive(timeKeeper.pulse) { _ in
            startBlockCheck()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            startBlockCheck()
        }
        .onReceive(SyncHeader.syncRx) { newData in
            viewModel.loadB()
        }
    }
    
    private func startBlockCheck() {
        guard SyncHeader.isConnected.value else { return }
        WalletService.startBlockCheck()
    }
    
    private func bottomView() -> some View {
        ScrollView(.horizontal) {
            LazyHStack {
                StatsView()
                    .frame(width: UIScreen.main.bounds.width)
                TransactionsListView()
                    .frame(width: UIScreen.main.bounds.width)
            }
        }
    }
    
    private func balanceView() -> some View {
        if let spotBalance = spotBalance {
            Text("$\(spotBalance)")
                .bold()
                .font(.title)
                .padding(0)
                .padding(.bottom, 10)
        } else {
            Text("$0.00")
                .bold()
                .font(.title)
                .padding(0)
                .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    private func balances() -> some View {
        if viewModel.zephyrBalance != viewModel.zephyrBalanceUnlocked {
            balance(viewModel.zephyrBalanceUnlocked,
                    type: .zephyr,
                    lockedBalance: viewModel.zephyrBalance)
        } else {
            balance(viewModel.zephyrBalanceUnlocked,
                    type: .zephyr,
                    lockedBalance: 0)
        }
        
        if viewModel.zephyrStableDollarsBalance != viewModel.zephyrStableDollarsBalanceUnlocked {
            balance(viewModel.zephyrStableDollarsBalanceUnlocked,
                    type: .stableDollars,
                    lockedBalance: viewModel.zephyrStableDollarsBalance)
        } else {
            balance(viewModel.zephyrStableDollarsBalanceUnlocked,
                    type: .stableDollars,
                    lockedBalance: 0)
        }
        
        if viewModel.zephyrReserveBalance != viewModel.zephyrReserveBalanceUnlocked {
            balance(viewModel.zephyrReserveBalanceUnlocked,
                    type: .reserve,
                    lockedBalance: viewModel.zephyrReserveBalance)
        } else {
            balance(viewModel.zephyrReserveBalanceUnlocked,
                    type: .reserve,
                    lockedBalance: 0)
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
    
    private func balance(_ balance: UInt64,
                         type: WalletViewModel.CurrencyType,
                         lockedBalance: UInt64) -> some View {
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
            
            VStack(alignment: .leading, spacing: 0) {
                if lockedBalance > 0, lockedBalance >= balance {
                    Text("LOCKED: \((lockedBalance - balance).formatHuman())")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Text(balance.formatHuman())
                    .font(.body)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            switch type {
            case .reserve:
               Text("ZRS")
                    .foregroundColor(.gray)
                    .font(.footnote)
            case .stableDollars:
                Text("ZSD")
                     .foregroundColor(.gray)
                     .font(.footnote)
            case .zephyr:
                Text("ZEPH")
                     .foregroundColor(.gray)
                     .font(.footnote)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func walletActions() -> some View {
        HStack {
            actionButton(title: "Send",
                         action: {
                router.changeRoot(to: .send)
            })
            
            Spacer()
            
            actionButton(title: "Receive",
                         action: {
                router.changeRoot(to: .receive)
            })
            
//            Spacer()
//            
//            if UserDefaults.standard.bool(forKey: "xx") {
//                actionButton(title: "Swap",
//                             action: {
//                    router.changeRoot(to: .swap)
//                })
//            }
        }
        .padding(.horizontal)
    }
}
