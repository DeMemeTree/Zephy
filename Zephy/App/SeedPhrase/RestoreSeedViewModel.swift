//
//  RestoreSeedViewModel.swift
//  Zephy
//
//
import SwiftUI
import Combine

final class RestoreSeedViewModel: ObservableObject {
    @Published var walletPassword = ""
    @Published var restoreHeight: String = "0"
    @Published var showPassword = true
    @Published var allWords: [String] = SeedPhraseService.allWords
    @Published var filteredWords: [String] = []
    @Published var selectedWords: [String] = []
    
    @Published var error = ""
    
    private var disposeBag = Set<AnyCancellable>()
    
    let searchDebounce = PassthroughSubject<String, Never>()
    
    init() {
        searchWord("")
        
        searchDebounce
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .throttle(for: 0.3, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] value in
                self?.searchWord(value)
            }.store(in: &disposeBag)
    }
    
    func searchWord(_ query: String) {
        if query.isEmpty {
            filteredWords = allWords
        } else {
            DispatchQueue.global(qos: .background).async {
                let results = self.allWords.filter { $0.contains(query.lowercased()) }
                DispatchQueue.main.async {
                    self.filteredWords = results
                }
            }
        }
    }

    func addWord(_ word: String) {
        if selectedWords.count < 25 {
            selectedWords.append(word)
            filteredWords = allWords
        }
    }
    
    func removeWord(_ index: Int) {
        selectedWords.remove(at: index)
    }

    func restoreWallet(router: Router) {
        UserDefaults.standard.setValue(UInt64(restoreHeight) ?? 0, forKey: "restoreHeight")
        WalletService.restoreWallet(seed: selectedWords.joined(separator: " "),
                                    password: walletPassword,
                                    restoreHeight: UInt64(restoreHeight) ?? 0)
            .backgroundToMain()
            .sink { [weak self] success in
                if success {
                    router.changeRoot(to: .wallet)
                } else {
                    self?.error = "There was an error restoring your wallet. Double check your seedphrase"
                }
            }.store(in: &disposeBag)
    }
}

