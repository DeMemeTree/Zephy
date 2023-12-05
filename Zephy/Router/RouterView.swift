//
//  RouterView.swift
//  Zephy
//
//
import SwiftUI

struct RouterView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            switch router.topView {
            case .splash:
                SplashView()
            case .wallet:
                WalletView()
            case .seedPhrase:
                SeedPhraseView()
            case .swap:
                SwapView()
            case .receive:
                ReceiveView()
            case .send:
                SendView()
            case .settings:
                SettingsView()
            }
            
            ConnectedView()
        }
    }
}
