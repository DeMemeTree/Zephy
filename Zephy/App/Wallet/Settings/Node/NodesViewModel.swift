//
//  NodesViewModel.swift
//  Zephy
//
//
import Foundation

class NodesViewModel: ObservableObject {
    @Published var node: String = ""
    @Published var login: String = ""
    @Published var secret: String = ""
    @Published var isConnected: Bool = false

    func connectToNode() async {
        isConnected = await WalletService.requestNode(node: node,
                                                      login: login,
                                                      secret: secret)
    }
}
