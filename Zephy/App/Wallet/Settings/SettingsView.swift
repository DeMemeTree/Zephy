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
    
    var body: some View {
        NavigationView {
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
                
                NodesView()
                    .frame(height: 400)
                
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
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
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
        .onAppear {
            guard let found = UserDefaults.standard.value(forKey: "restoreHeight") as? UInt64 else { 
                return }
            restoreHeight = String(found)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        closeKeyboard()
                    }
                }
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
        .foregroundColor(.white)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
    }
    
    private func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
