//
//  SeedPhraseViewModel.swift
//  Zephy
//
//
import Combine
import Foundation

class SeedPhraseViewModel: ObservableObject {
    enum SeedPhraseState {
        case none
        case create
        case confirm
    }
    
    struct AlertMessage: Identifiable {
        let id = UUID()
        let text: String
    }
    
    @Published var walletPassword = ""
    @Published var seedPhrase = ""
    @Published var showPassword = true
    @Published var seedCreationState: SeedPhraseState = .none
    @Published var confirmationInput = ""
    @Published var indicesToConfirm: [Int] = []
    
    @Published var error: AlertMessage?
    
    private var disposeBag = Set<AnyCancellable>()
    
    private var secretPassword: String?

    func createWallet() {
        WalletService.createWallet(password: walletPassword)
            .backgroundToMain()
            .sink { [weak self] success in
                guard let self = self else { return }
                if success, KeychainService.save(password: walletPassword) {
                    generateSeedPhrase()
                    seedCreationState = .create
                } else {
                    error = AlertMessage(text: "Wallet password is not correct")
                }
            }.store(in: &disposeBag)
    }

    func confirmSeedPhrase() -> Bool {
        let words = confirmationInput.split(separator: " ").map(String.init)
        for (index, word) in words.enumerated() {
            let seedIndex = indicesToConfirm[index]
            let seedWord = seedPhrase.split(separator: " ")[seedIndex]
            if word != seedWord {
                return false
            }
        }
        return secretPassword == walletPassword
    }
    
    func prepareForSeedConfirmation() {
        var indicesSet = Set<Int>()
        while indicesSet.count < 3 {
            let randomNumber = Int.random(in: 1...25)
            indicesSet.insert(randomNumber - 1)
        }
        indicesToConfirm = Array(indicesSet).sorted()
        
        // clear the password so they need to confirm it later
        secretPassword = walletPassword
        walletPassword = ""
        seedCreationState = .confirm
    }

    private func generateSeedPhrase() {
        let seed = WalletService.seedPhrase()
        if KeychainService.save(seed: seed) == false {
            #warning("Do some sort of UI display and let the user attempt to resave it to keychain")
        }
        seedPhrase = seed
    }
}
