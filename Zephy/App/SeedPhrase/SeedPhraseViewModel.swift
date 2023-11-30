//
//  SeedPhraseViewModel.swift
//  Zephy
//
//
import Combine
import ZephySDK

class SeedPhraseViewModel: ObservableObject {
    enum SeedPhraseState {
        case none
        case create
        case confirm
    }
    
    @Published var walletPassword = ""
    @Published var seedPhrase = "word1 word2 word3 ... word25"
    @Published var seedPhraseRestore = ""
    @Published var showPassword = true
    @Published var isRestoreViewActive = false
    @Published var seedCreationState: SeedPhraseState = .none
    @Published var confirmationInput = ""
    @Published var indicesToConfirm: [Int] = []

    func createWallet() {
        seedPhrase = generateSeedPhrase()
        indicesToConfirm = selectRandomIndices()
        seedCreationState = .create
        
        // TODO: Still working on getting this to complete without freezing...
//        DispatchQueue.global(qos: .background).async {
//            do {
//                let address = UnsafeMutablePointer<CChar>(mutating: ("http://remote-node.zephyrprotocol.com:17767" as NSString).utf8String)
//                let nLogin = UnsafeMutablePointer<CChar>(mutating: ("" as NSString).utf8String)
//                let nPassword = UnsafeMutablePointer<CChar>(mutating: ("" as NSString).utf8String)
//                let error = UnsafeMutablePointer<CChar>(mutating: ("" as NSString).utf8String)
//
//                let nodeResult = setup_node(address,
//                                            nLogin,
//                                            nPassword,
//                                            false,
//                                            false,
//                                            error)
//                print("Result of setting up node: \(nodeResult)")
//                            
//                let password = "TestPasswordForEncryption"
//                let language = "English"
//                
//                let path = try FileService.pathForWallet(name: "Test")
//                let pathC = (path.path() as NSString).utf8String
//                let pathMP = UnsafeMutablePointer<CChar>(mutating: pathC)
//                
//                
//                let cPassword = (password as NSString).utf8String
//                let passwordMP = UnsafeMutablePointer<CChar>(mutating: cPassword)
//                
//                let cLanguage = (language as NSString).utf8String
//                let languageMP = UnsafeMutablePointer<CChar>(mutating: cLanguage)
//                
//                let result = create_wallet(pathMP, passwordMP, languageMP, error)
//                print("iOS Zephyr Wallet Created: \(result)")
//                
//               // print(error)
//            } catch {
//                print(error)
//            }
//        }
    }

    func restoreWallet() {
        // Implement wallet restoration logic here
    }

    func confirmSeedPhrase() -> Bool {
        return true
        
//        let words = confirmationInput.split(separator: " ").map(String.init)
//        for (index, word) in words.enumerated() {
//            let seedIndex = indicesToConfirm[index]
//            let seedWord = seedPhrase.split(separator: " ")[seedIndex]
//            if word != seedWord {
//                return false
//            }
//        }
//        return true
    }
    
    func prepareForSeedConfirmation() {
        // Here you would randomly select three indices for the user to confirm
        indicesToConfirm = [Int.random(in: 1...25), Int.random(in: 1...25), Int.random(in: 1...25)].sorted()
        seedCreationState = .confirm
    }

    private func generateSeedPhrase() -> String {
        // Implement the logic to generate a 25-word seed phrase
        // Placeholder implementation
        return (1...25).map { "word\($0)" }.joined(separator: " ")
    }
    
    func addEntropy(entropyValue: Int) {
        // Use entropyValue to add entropy to the seed generation process
        // This is a placeholder for where you would integrate with your crypto library
        seedPhrase = regenerateSeedPhrase(withEntropy: entropyValue)
    }
    
    private func regenerateSeedPhrase(withEntropy entropy: Int) -> String {
        // Implement the logic to regenerate the 25-word seed phrase using the additional entropy
        // This is a placeholder function
        return (1...25).map { "word\($0)\(entropy)" }.joined(separator: " ")
    }

    private func selectRandomIndices() -> [Int] {
        // Implement the logic to select 3 random indices for the user to confirm
        // Placeholder implementation
        return [12, 17, 19] // Replace this with actual random selection
    }
}
