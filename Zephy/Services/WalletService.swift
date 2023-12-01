//
//  WalletService.swift
//  Zephy
//
//
import Combine
import ZephySDK

struct WalletService {
    static var password = "TestPasswordForEncryption"
    
    static func currentWalletName() -> String {
        return "Test"
    }
    
    static func doesWalletExist() -> Bool {
        guard let path = try? FileService.pathForWallet(name: currentWalletName()) else { return false }
        let pathC = (path.path() as NSString).utf8String
        let pathMP = UnsafeMutablePointer<CChar>(mutating: pathC)
        if is_wallet_exist(pathMP) {
            let cPassword = (password as NSString).utf8String
            let passwordMP = UnsafeMutablePointer<CChar>(mutating: cPassword)
            return load_wallet(pathMP,
                               passwordMP,
                               0)
        }
        return false
    }
    
    static func createWallet(password: String) -> AnyPublisher<Bool, Never> {
        let publisher = PassthroughSubject<Bool, Never>()
        DispatchQueue.global(qos: .background).async {
            do {
                
                if doesWalletExist() == false {
                    let language = "English"
                    
                    let path = try FileService.pathForWallet(name: currentWalletName())
                    let pathC = (path.path() as NSString).utf8String
                    let pathMP = UnsafeMutablePointer<CChar>(mutating: pathC)
                    
                    let cPassword = (password as NSString).utf8String
                    let passwordMP = UnsafeMutablePointer<CChar>(mutating: cPassword)
                    
                    let cLanguage = (language as NSString).utf8String
                    let languageMP = UnsafeMutablePointer<CChar>(mutating: cLanguage)
                    
                    let error = UnsafeMutablePointer<CChar>(mutating: ("" as NSString).utf8String)
                    
                    let result = create_wallet(pathMP, passwordMP, languageMP, error)
                }
                publisher.send(true)
                publisher.send(completion: .finished)
            } catch {
                print(error)
                publisher.send(false)
                publisher.send(completion: .finished)
            }
        }
        return publisher.eraseToAnyPublisher()
    }
    
    static func seedPhrase() -> String {
        return String(cString: seed())
    }
    
    static func currentZephBalance() -> UInt64 {
        return get_full_balance(0)
    }
}
