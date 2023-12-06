//
//  NodesViewModel.swift
//  Zephy
//
//
import Foundation


class NodesViewModel: ObservableObject {
    enum State {
        case needsFetch
        case loading
        case found([NodeService.Node])
    }
    
    @Published var node: String = ""
    @Published var login: String = ""
    @Published var secret: String = ""
    @Published var isConnected: Bool = false
    
    @Published var state: State = .needsFetch
    
    init() {
        if let node = KeychainService.fetchNode() {
            isConnected = WalletService.isConnected()
            self.node = node
        }
        if let login = KeychainService.fetchNodeLogin() {
            self.login = login
        }
        if let password = KeychainService.fetchNodePassword() {
            self.secret = password
        }
    }

    @MainActor
    func connectToNode() async {
        isConnected = await WalletService.connect(node: node,
                                                  login: login,
                                                  password: secret)
    }
    
    func fetch() {
        state = .loading
        Task(priority: .background) {
            do {
                let nodes = try await NodeService.fetchNodes()
                DispatchQueue.main.async {
                    self.state = .found(nodes)
                }
            } catch {
                DispatchQueue.main.async {
                    self.state = .needsFetch
                }
                Logger.log(error: error)
            }
        }
    }
}
