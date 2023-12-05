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

    func connectToNode() async {
        isConnected = await WalletService.requestNode(node: node,
                                                      login: login,
                                                      secret: secret)
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
