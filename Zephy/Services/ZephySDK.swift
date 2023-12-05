//
//  ZephySDK.swift
//  Zephy
//
//
import Foundation
import JavaScriptCore

struct ZephySDK {
    struct CreateWallet: Encodable {
        var path: String?
        var password: String
        var networkType: String
        var server: ZephyRPCConnection
        var mnemonic: String?
        var seedOffset: String?
        var primaryAddress: String?
        var privateViewKey: String?
        var privateSpendKey: String?
        var restoreHeight: Int?
        var proxyToWorker: Bool?

        struct ZephyRPCConnection: Encodable {
            var uri: String
            var username: String?
            var password: String?
            var rejectUnauthorized: Bool?
        }
    }
    
    
    static let shared = ZephySDK()
    let context: JSContext
    let vm = JSVirtualMachine()
    
    private init() {
        let jsCode = try? String.init(contentsOf: Bundle.main.url(forResource: "ZephySDK.bundle", withExtension: "js")!)
        // The Swift closure needs @convention(block) because JSContext's setObject:forKeyedSubscript: method
        // expects an Objective-C compatible block in this instance.
        // For more information check out https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Attributes.html#//apple_ref/doc/uid/TP40014097-CH35-ID350
        let nativeLog: @convention(block) (String) -> Void = { message in
            Logger.log(error: NSError(domain: message, code: 42))
        }
        context = JSContext(virtualMachine: vm)
        context.setObject(nativeLog, forKeyedSubscript: "nativeLog" as NSString)
        context.evaluateScript(jsCode)
    }
    
    func createWallet(walletData: CreateWallet) async -> Bool {
        let jsonData = try? JSONEncoder().encode(walletData)
        guard let jsonString = String(data: jsonData ?? Data(), encoding: .utf8) else {
            return false
        }

        if let createWalletFunction = context.objectForKeyedSubscript("createWallet") {
            let result = createWalletFunction.call(withArguments: [jsonString])
            print("result: \(result?.toBool())")
            return result?.toBool() ?? false
        }
        
        return false
    }
}
