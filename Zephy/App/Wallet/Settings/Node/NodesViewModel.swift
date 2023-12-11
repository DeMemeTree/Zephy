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
    
    enum ConnectionState {
        case connected
        case loading
        case notConnected
    }
    
    @Published var node: String = ""
    @Published var login: String = ""
    @Published var secret: String = ""
    @Published var connectedState: ConnectionState = .loading
    
    @Published var state: State = .needsFetch
    
    init() {
        if let node = KeychainService.fetchNode() {
            connectedState = WalletService.isConnected() ? .connected : .notConnected
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
        connectedState = .loading
        let res = await WalletService.connect(node: node,
                                              login: login,
                                              password: secret)
        connectedState = res ? .connected : .notConnected
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
