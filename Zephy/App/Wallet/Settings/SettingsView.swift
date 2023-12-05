//
//  SettingsView.swift
//  Zephy
//
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var router: Router
    @State private var showingSeedPhraseAlert = false
    @State private var showSeedPhraseView = false
    
    var body: some View {
        NavigationView {
            VStack {
                NodesView()
                
                Button(showSeedPhraseView ? "Hide Seed" : "Show Seed Phrase") {
                    showingSeedPhraseAlert.toggle()
                }
                
                if showSeedPhraseView,
                   let seed = KeychainService.fetchSeed() {
                    SeedPhraseGrid(seedPhrase: seed)
                }
            }
            .background(Color.zephyPurp)
            .alert(isPresented: $showingSeedPhraseAlert) {
                Alert(
                    title: Text("Confirm"),
                    message: Text("Your seed phrase will be shown. Make sure you are in a secure environment."),
                    primaryButton: .default(Text("Show"), action: {
                        showSeedPhraseView = true
                    }),
                    secondaryButton: .cancel()
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.changeRoot(to: .wallet)
                    }) {
                        Image(systemName: "arrow.left")
                    }
                }
            }
        }
    }
}
