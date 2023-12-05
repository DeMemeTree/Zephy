//
//  WalletService.swift
//  Zephy
//
//
import Combine
import ZephySDK

struct WalletService {
    static func currentWalletName() -> String {
        return "Test"
    }
    
    static func doesWalletExist(password: String? = nil) -> Bool {
        guard let path = try? FileService.pathForWallet(name: currentWalletName()) else { return false }
        let pathC = (path.path() as NSString).utf8String
        let pathMP = UnsafeMutablePointer<CChar>(mutating: pathC)
        if is_wallet_exist(pathMP),
           let password = password ?? KeychainService.password() {
            let cPassword = (password as NSString).utf8String
            let passwordMP = UnsafeMutablePointer<CChar>(mutating: cPassword)
            return load_wallet(pathMP,
                               passwordMP,
                               0)
        }
        return false
    }
    
    static func restoreWallet(seed: String,
                              password: String,
                              restoreHeight: UInt64) -> AnyPublisher<Bool, Never> {
        let publisher = PassthroughSubject<Bool, Never>()
        DispatchQueue.global(qos: .background).async {
            do {
                let path = try FileService.pathForWallet(name: currentWalletName())
                let pathC = (path.path() as NSString).utf8String
                let pathMP = UnsafeMutablePointer<CChar>(mutating: pathC)
                
                let cPassword = (password as NSString).utf8String
                let passwordMP = UnsafeMutablePointer<CChar>(mutating: cPassword)
                
                let cSeed = (seed as NSString).utf8String
                let seedMP = UnsafeMutablePointer<CChar>(mutating: cSeed)
                
                let error = UnsafeMutablePointer<CChar>(mutating: ("" as NSString).utf8String)
                
                let result = restore_wallet_from_seed(pathMP,
                                                      passwordMP,
                                                      seedMP,
                                                      restoreHeight,
                                                      error)
                
                publisher.send(result)
                publisher.send(completion: .finished)
            } catch {
                Logger.log(error: error)
                publisher.send(false)
                publisher.send(completion: .finished)
            }
        }
        return publisher.eraseToAnyPublisher()
    }
    
    static func createWallet(password: String) -> AnyPublisher<Bool, Never> {
        let publisher = PassthroughSubject<Bool, Never>()
        DispatchQueue.global(qos: .background).async {
            if doesWalletExist(password: password) == false {
//                    let language = "English"
//
//                    let path = try FileService.pathForWallet(name: currentWalletName())
//                    let pathC = (path.path() as NSString).utf8String
//                    let pathMP = UnsafeMutablePointer<CChar>(mutating: pathC)
//
//                    let cPassword = (password as NSString).utf8String
//                    let passwordMP = UnsafeMutablePointer<CChar>(mutating: cPassword)
//
//                    let cLanguage = (language as NSString).utf8String
//                    let languageMP = UnsafeMutablePointer<CChar>(mutating: cLanguage)
//
//                    let error = UnsafeMutablePointer<CChar>(mutating: ("" as NSString).utf8String)
//
//                    let result = create_wallet(pathMP, passwordMP, languageMP, error)
//                    publisher.send(result)
                Task(priority: .background) {
                    do {
                        let path = try FileService.pathForWallet(name: currentWalletName()).path(percentEncoded: true)
                        let data = ZephySDK.CreateWallet(path: path,
                                                         password: password,
                                                         networkType: "mainnet",
                                                         server: ZephySDK.CreateWallet.ZephyRPCConnection(uri: "http://remote-node.zephyrprotocol.com:17767"))
                        let result = await ZephySDK.shared.createWallet(walletData: data)
                        publisher.send(result)
                    } catch {
                        Logger.log(error: error)
                    }
                }
            } else {
                publisher.send(true)
            }
            publisher.send(completion: .finished)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    static func seedPhrase() -> String {
        return String(cString: seed())
    }
    
    static func currentZephBalance() -> UInt64 {
        return get_full_balance(0)
    }
    
    
    static func requestNode(node: String,
                            login: String? = nil,
                            secret: String? = nil) async -> Bool {
        guard let uri = URL(string: node) else { return false }
        let useSocksProxy = false
        let isSSL = uri.scheme == "https"
        let path = "/json_rpc"
        let rpcUri = isSSL ? URL(string: "https://\(uri.host!)\(path)")! : URL(string: "http://\(uri.host!)\(path)")!
        let body: [String: Any] = ["jsonrpc": "2.0", "id": "0", "method": "get_info"]

        if uri.absoluteString.contains(".onion") || useSocksProxy {
            return false
        }

        var request = URLRequest(url: rpcUri)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let login = login ?? ""
        let password = secret ?? ""
        let loginString = "\(login):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await NetworkService.requestData(with: request)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let result = json["result"] as? [String: Any],
               let offline = result["offline"] as? Bool {
                return !offline
            }
        } catch {
            Logger.log(error: error)
            return false
        }

        return false
    }
}
