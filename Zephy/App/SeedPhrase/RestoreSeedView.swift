//
//  RestoreSeedView.swift
//  Zephy
//
//
import Combine
import SwiftUI

final class RestoreSeedViewModel: ObservableObject {
    @Published var walletPassword = ""
    @Published var seedPhraseRestore = ""
    @Published var restoreHeight: String = "0"
    @Published var showPassword = true
    
    private var disposeBag = Set<AnyCancellable>()
    
    func restoreWallet(router: Router) {
        WalletService.restoreWallet(seed: seedPhraseRestore,
                                    password: walletPassword,
                                    restoreHeight: UInt64(restoreHeight) ?? 0)
            .backgroundToMain()
            .sink { success in
                if success {
                    router.changeRoot(to: .wallet)
                }
            }.store(in: &disposeBag)
    }
}

struct RestoreSeedView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = RestoreSeedViewModel()
    
    var body: some View {
        VStack {
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

            
            Button(action: {
                viewModel.restoreWallet(router: router)
            }) {
                Text("Restore")
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
