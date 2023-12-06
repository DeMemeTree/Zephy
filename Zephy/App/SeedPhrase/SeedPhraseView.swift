//
//  SeedPhraseView.swift
//  Zephy
//
//
import SwiftUI
import Combine

struct SeedPhraseView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = SeedPhraseViewModel()
    @State private var entropyCounter = 0

    var body: some View {
        VStack {
            Text(viewModel.isRestoreViewActive ? "Restore Wallet" : "Create a Wallet")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Privately store, exchange, and transfer assets without ever relinquishing custody.")
                .font(.headline)
                .padding(.bottom, 10)

            
            if viewModel.isRestoreViewActive {
                Text("Enter your 25 word seed phrase...")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
                
                TextEditor(text: $viewModel.seedPhraseRestore)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding()
                
                Text("Restore Height")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
                
                TextField("", text: Binding(
                            get: { self.viewModel.restoreHeight },
                            set: { newValue in
                                if let _ = UInt(newValue) {
                                    self.viewModel.restoreHeight = newValue
                                } else if newValue.isEmpty {
                                    self.viewModel.restoreHeight = ""
                                } else {
                                    self.viewModel.restoreHeight = String(self.viewModel.restoreHeight.filter { "0123456789".contains($0) })
                                }
                            }
                        ))
                        .foregroundColor(.white)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

            } else if viewModel.seedCreationState != .none {
                if viewModel.seedCreationState == .create {
                    Text("Write down all 25 words and keep the seed phrase secure.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    SeedPhraseGrid(seedPhrase: viewModel.seedPhrase)

                    Button("I've written down the seed phrase", action: viewModel.prepareForSeedConfirmation)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .padding()
                } else {
                    Text("Enter seed words #\(viewModel.indicesToConfirm.map(String.init).joined(separator: " #")) separated by blank space")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding()

                    TextEditor(text: $viewModel.confirmationInput)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                    
                    Text("Confirm Password")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    passwordView()
                    
                    Button("Confirm", action: {
                        if viewModel.confirmSeedPhrase() {
                            router.changeRoot(to: .wallet)
                        }
                    })
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding()
                }
            } else {
                passwordView()
            }

            if viewModel.isRestoreViewActive == false,
               viewModel.seedCreationState == .none {
                Text("Enter a strong password to create a wallet. You will be asked to confirm this password on the final step. This process will generate an encrypted wallet file that enables you to store, send and convert assets in complete privacy.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Spacer()
            
            
            if viewModel.seedCreationState == .none || viewModel.isRestoreViewActive {
                Button(action: {
                    if viewModel.isRestoreViewActive {
                        viewModel.restoreWallet(router: router)
                    } else {
                        viewModel.createWallet()
                    }
                }) {
                    Text(viewModel.isRestoreViewActive ? "Restore" : "Create")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                .padding()
            }

            if viewModel.seedCreationState == .none {
                HStack {
                    Button("Create", action: {
                        viewModel.isRestoreViewActive = false
                    })
                    .padding()
                    
                    Button("Restore", action: {
                        viewModel.isRestoreViewActive = true
                    })
                    .padding()
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.horizontal)
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Alert"),
                  message: Text(error.text),dismissButton: .default(Text("Okay")))
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil,
                                            from: nil,
                                            for: nil)
        }
    }

    private func passwordView() -> some View {
        HStack {
            if viewModel.showPassword {
                TextField("Wallet Password", text: $viewModel.walletPassword)
                    .foregroundColor(.white)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else {
                SecureField("Wallet Password", text: $viewModel.walletPassword)
                    .foregroundColor(.white)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Button(viewModel.showPassword ? "HIDE" : "SHOW", action: { viewModel.showPassword.toggle() })
                .padding(.trailing, 10)
        }
    }
}
