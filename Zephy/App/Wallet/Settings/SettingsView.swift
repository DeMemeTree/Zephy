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
    @State var restoreHeight = "0"
    
    @State var selectedView: Int = 0
    
    var appVersion: String {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
           let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return "Build: \(version) (\(build))"
        }
        return "Unknown Version"
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                topNav()
                
                Text(appVersion)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
                
                if selectedView == 0 {
                    appSettings()
                } else {
                    NodesView()
                }
            }
            .onAppear {
                guard let found = UserDefaults.standard.value(forKey: "restoreHeight") as? UInt64 else {
                    return }
                restoreHeight = String(found)
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
    
    func topNav() -> some View {
        Picker("Select Asset", selection: $selectedView) {
            Text("App Settings").tag(0)
            Text("Node Settings").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
    func appSettings() -> some View {
        ScrollView {
            HStack {
                restoreHeightView()
            }
            .padding(.horizontal)
            
            Text("Only do this if balances are incorrect or updated restore height has changed")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.vertical, 5)
                .padding(.horizontal)
            
            Button {
                guard let restoreHeight = UInt64(restoreHeight) else { return }
                UserDefaults.standard.setValue(restoreHeight, forKey: "restoreHeight")
                WalletService.restore(height: restoreHeight)
                WalletService.rescanBlockchain()
                router.changeRoot(to: .wallet)
            } label: {
                Text("Rescan Blockchain")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            .padding()
            
            Button {
                if showSeedPhraseView {
                    showSeedPhraseView.toggle()
                } else {
                    showingSeedPhraseAlert.toggle()
                }
            } label: {
                Text(showSeedPhraseView ? "Hide Seed" : "Show Seed Phrase")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding(.bottom)
            }
            .padding(.horizontal)
            
            if showSeedPhraseView,
               let seed = KeychainService.fetchSeed() {
                SeedPhraseGrid(seedPhrase: seed)
            }
        }
    }
    
    @ViewBuilder
    private func restoreHeightView() -> some View {
        Text("Restore Height (Optional)")
            .font(.footnote)
            .foregroundColor(.gray)
            .padding()
        
        TextField("", text: Binding(
            get: { restoreHeight },
            set: { newValue in
                if let _ = UInt(newValue) {
                    restoreHeight = newValue
                } else if newValue.isEmpty {
                    self.restoreHeight = ""
                } else {
                    self.restoreHeight = String(self.restoreHeight.filter { "0123456789".contains($0) })
                }
            }
        ))
        .keyboardType(.numberPad)
        .foregroundColor(.white)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .keyboardCloseButton()
    }
}
