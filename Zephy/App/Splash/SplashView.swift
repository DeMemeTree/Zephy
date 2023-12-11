//
//  SplashView.swift
//  Zephy
//
//
import SwiftUI
import ZephySDK

struct SplashView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Image("zeph")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame( width: 100, height: 100)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.zephyPurp)
        .onAppear {
            router.changeRoot(to: WalletService.doesWalletExist() ? .wallet : .onboarding)
        }
    }
}
