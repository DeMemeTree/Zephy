//
//  WalletService.swift
//  Zephy
//
//
import Combine
import ZephySDK

struct WalletService {
    struct PricingRecord: Codable {
        var height: UInt64
        var timestamp: Int
        var spot: Double
        var movingAverage: Double
        var reserve: Double
        var reserveMa: Double
        var stable: Double
        var stableMa: Double
    }
    
    private static let DEATOMIZE: Double = pow(10, -12)
    private static var refreshTimer: Timer?
    
    static func currentWalletName() -> String {
        return "Test"
    }
    
    static func seedPhrase() -> String {
        return String(cString: seed())
    }
    
    static func restore(height: UInt64) {
        set_refresh_from_block_height(height)
    }
    
    static func currentAssetBalance(asset: Assets, full: Bool) -> UInt64 {
        let assetTypeC = (asset.rawValue as NSString).utf8String
        let assetTypeMP = UnsafeMutablePointer<CChar>(mutating: assetTypeC)
        return full ? get_full_balance(assetTypeMP, 0) : get_unlocked_balance(assetTypeMP, 0)
    }
    
    static func isConnected() -> Bool {
        return is_connected()
    }
    
    static func storeWallet() {
        guard TimeKeeper.isProtectedDataAvailable.value else { return }
        guard let path = try? FileService.pathForWallet(name: currentWalletName()) else { return }
        let pathC = (path.path() as NSString).utf8String
        let pathMP = UnsafeMutablePointer<CChar>(mutating: pathC)
        store(pathMP)
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
    
    static func allAddresses() -> [(String, String)] {
        var retVal = [(String, String)]()
        var count = subaddrress_size()
        if count == 0 {
            let nameC = ("Address #1" as NSString).utf8String
            let nameMP = UnsafeMutablePointer<CChar>(mutating: nameC)
            subaddress_add_row(0, nameMP);
            storeWallet()
            count = subaddrress_size()
        }
        
        (0..<count).forEach { index in
            if let subAddy = get_subaddress_label(0, UInt32(index)) {
                var found = String(cString: subAddy)
                if (found == "Address #1" && index != 1) || found.isEmpty {
                    found = "Address #\(index)"
                }
                if let account = get_subaddress_account(0, UInt32(index)) {
                    retVal.append((found, String(cString: account)))
                }
            }
        }
        return retVal
    }
    
    static func createSubaddress() {
        let count = subaddrress_size()
        let nameC = ("Address #\(count + 1)" as NSString).utf8String
        let nameMP = UnsafeMutablePointer<CChar>(mutating: nameC)
        subaddress_add_row(0, nameMP)
        storeWallet()
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
                
                if result {
                    storeWallet()
                }
                
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
                do {
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
                    
                    if result {
                        storeWallet()
                    }
                    
                    publisher.send(result)
                } catch {
                    Logger.log(error: error)
                }
            } else {
                publisher.send(true)
            }
            publisher.send(completion: .finished)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    static func transactionCreate(assetType: String,
                                  destAssetType: String,
                                  toAddress: String,
                                  amount: String,
                                  sendAll: Bool) -> AnyPublisher<UInt64, Never> {
        let publisher = PassthroughSubject<UInt64, Never>()
        DispatchQueue.global(qos: .background).async {
            let cSource = (assetType as NSString).utf8String
            let sourceMP = UnsafeMutablePointer<CChar>(mutating: cSource)
            
            let cDest = (destAssetType as NSString).utf8String
            let destMP = UnsafeMutablePointer<CChar>(mutating: cDest)
            
            let cToAddy = (toAddress as NSString).utf8String
            let addyMP = UnsafeMutablePointer<CChar>(mutating: cToAddy)
            
            let cAmount = (amount as NSString).utf8String
            let amountMP = UnsafeMutablePointer<CChar>(mutating: cAmount)
            
            let error = UnsafeMutablePointer<CChar>(mutating: ("" as NSString).utf8String)
            
            let result = transaction_create(sourceMP,
                                            destMP,
                                            addyMP,
                                            sendAll ? nil : amountMP,
                                            error)
//            if result {
//                storeWallet()
//            }
            publisher.send(result)
            publisher.send(completion: .finished)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    struct TransactionInfoRowSwift {
        let amount: UInt64
        let fee: UInt64
        let blockHeight: UInt64
        let confirmations: UInt64
        let subaddrAccount: UInt32
        let direction: Int8
        let isPending: Int8
        let subaddrIndex: UInt32
        let hash: UnsafePointer<CChar>?
        let source_type: UnsafePointer<CChar>?
        let datetime: Int64
    }

    static func fetchAllTransactions(ofType: String) -> [TransactionInfoRowSwift] {
        transactions_refresh()
        let count = transactions_count()
        guard let transactionAddresses = transactions_get_all() else {
            return [] }

        var result = [TransactionInfoRowSwift]()
        for i in 0..<count {
            let transactionAddress = transactionAddresses.advanced(by: i).pointee
            guard let bitPat = UnsafeRawPointer(bitPattern: UInt(transactionAddress)) else { continue }
            let transactionPointer = bitPat.assumingMemoryBound(to: TransactionInfoRowSwift.self)

            let transactionData = transactionPointer.pointee
            if let source_type = transactionData.source_type, String(cString: source_type) == ofType {
                result.append(transactionData)
            }
        }
        
        let sort = result.sorted { a, b in
            if a.blockHeight == 0 && b.blockHeight != 0 {
                return true
            } else if a.blockHeight != 0 && b.blockHeight == 0 {
                return false
            } else {
                return a.blockHeight > b.blockHeight
            }
        }
        
        free(transactionAddresses)
        // Lol to not overwhelm the UI
        if sort.count > 250 {
            return Array(sort.prefix(250))
        } else {
            return sort
        }
    }

    
    static func commitTransaction() -> AnyPublisher<Bool, Never> {
        let publisher = PassthroughSubject<Bool, Never>()
        DispatchQueue.global(qos: .background).async {
            let result = transaction_commit()
            if result {
                storeWallet()
                transactions_refresh()
                startBlockCheck()
            }
            publisher.send(result)
            publisher.send(completion: .finished)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    static func connect(node: String,
                        login: String?,
                        password: String?) async -> Bool {
        let testConection = await WalletService.requestNode(node: node,
                                                            login: login,
                                                            secret: password)
        
        if testConection {
            KeychainService.save(node: node,
                                 login: login,
                                 password: password)
            let retval = WalletService.connectToNode(address: node,
                                               login: login,
                                               password: password)
            
            if retval {
                start_refresh()
                startBlockCheck()
                
            }
            return retval
        }
        return false
    }
    
    static func rescanBlockchain() {
        DispatchQueue.global(qos: .background).async {
            rescan_blockchain()
        }
    }
    
    static func startBlockCheck() {
        guard refreshTimer == nil else { return }
        
        var current: UInt64 = 0
        var node: UInt64 = 1
        var syncVal: Bool = false
        if isConnected() {
            current = get_current_height()
            node = get_node_height()
            syncVal = synchronized()
            print("Current: \(current)")
            print("Node: \(node)")
            print("Synchronized: \(syncVal)")
        }
        guard current != node || syncVal == false else {
            DispatchQueue.main.async {
                SyncHeader.syncRx.send(SyncHeader.BlockData(currentBlock: current,
                                                            targetBlock: node,
                                                            synchronized: true))
            }
            return }
        
        stopCheck()
        DispatchQueue.main.async {
            SyncHeader.syncRx.send(SyncHeader.BlockData(currentBlock: current,
                                                        targetBlock: node,
                                                        synchronized: syncVal))
            refreshTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                DispatchQueue.global(qos: .background).async {
                    guard isConnected() else { return }
                    current = get_current_height()
                    node = get_node_height()
                    syncVal = synchronized()
                    print("Current: \(current)")
                    print("Node: \(node)")
                    print("Synchronized: \(syncVal)")
                    DispatchQueue.main.async {
                        SyncHeader.syncRx.send(SyncHeader.BlockData(currentBlock: current,
                                                                    targetBlock: node,
                                                                    synchronized: syncVal))
                    }
                    if syncVal, current == node {
                        stopCheck()
                        WalletService.storeWallet()
                    }
                }
            }
        }
    }
    
    static func stopCheck() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private static func connectToNode(address: String,
                                      login: String?,
                                      password: String?,
                                      useSSL: Bool = false,
                                      isLight: Bool = false) -> Bool {
        let cAddy = (address as NSString).utf8String
        let addyMP = UnsafeMutablePointer<CChar>(mutating: cAddy)
        
        let cLogin = ((login ?? "") as NSString).utf8String
        let loginMP = UnsafeMutablePointer<CChar>(mutating: cLogin)
        
        let cPassword = ((password ?? "") as NSString).utf8String
        let passwordMP = UnsafeMutablePointer<CChar>(mutating: cPassword)
        
        
        let cError = ("" as NSString).utf8String
        let errorMP = UnsafeMutablePointer<CChar>(mutating: cError)
        
        let _ = setup_node(addyMP,
                           loginMP,
                           passwordMP,
                           useSSL,
                           isLight,
                           errorMP)
        
        return connect_to_node(errorMP)
    }
    
    private static func requestNode(node: String,
                                    login: String? = nil,
                                    secret: String? = nil) async -> Bool {
        guard let uri = URL(string: node + "/json_rpc") else { return false }
        let body: [String: Any] = ["jsonrpc": "2.0", "id": "0", "method": "get_info"]

        if uri.absoluteString.contains(".onion") {
            return false
        }

        var request = URLRequest(url: uri)
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
    
    static func getCurrentBlockHeight() async -> UInt64 {
        guard let node = KeychainService.fetchNode() else { return 0 }
        
        guard let url = URL(string: "\(node)/get_height") else {
            return 0
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let height = json["height"] as? UInt64 {
                if height >= 2 {
                    return height - 1
                }
                return height
            }
        } catch {
            print("Error: \(error)")
        }

        return 0
    }
    
    static func getBlock(height: UInt64) async -> [String: Any]? {
        guard let node = KeychainService.fetchNode() else { return nil }
        
        guard let url = URL(string: "\(node)/json_rpc") else {
            return nil
        }

        let body: [String: Any] = [
            "jsonrpc": "2.0",
            "id": "0",
            "method": "get_block",
            "params": ["height": height]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONSerialization.jsonObject(with: data) as? [String: Any]
        } catch {
            print("Error: \(error)")
            return nil
        }
    }

    static func getPricingRecordFromBlock(height: UInt64) async -> PricingRecord? {
        guard let blockData = await getBlock(height: height) else {
            return nil
        }
        
        guard let result = blockData["result"] as? [String: Any],
              let blockHeader = result["block_header"] as? [String: Any],
              let pricingRecordData = blockHeader["pricing_record"] as? [String: Any] else {
            return nil
        }

        let pricingRecord = PricingRecord(
            height: height,
            timestamp: pricingRecordData["timestamp"] as? Int ?? 0,
            spot: (pricingRecordData["spot"] as? Double ?? 0) * DEATOMIZE,
            movingAverage: (pricingRecordData["moving_average"] as? Double ?? 0) * DEATOMIZE,
            reserve: (pricingRecordData["reserve"] as? Double ?? 0) * DEATOMIZE,
            reserveMa: (pricingRecordData["reserve_ma"] as? Double ?? 0) * DEATOMIZE,
            stable: (pricingRecordData["stable"] as? Double ?? 0) * DEATOMIZE,
            stableMa: (pricingRecordData["stable_ma"] as? Double ?? 0) * DEATOMIZE
        )

        return pricingRecord
    }
}
