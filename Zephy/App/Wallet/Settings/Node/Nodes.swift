//
//  Nodes.swift
//  Zephy
//
//
import SwiftUI

struct Nodes: View {
    @StateObject var viewModel = NodesViewModel()

    var body: some View {
        List {
            Section(header: Text("Node Settings")) {
                VStack(alignment: .leading) {
                    Text("Please include the port in the node URL (127.0.0.1:17767)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    TextField("Node", text: $viewModel.node)
                }
                TextField("Login (optional)", text: $viewModel.login)
                SecureField("Secret (optional)", text: $viewModel.secret)
            }

            Button(action: {
                Task {
                    await viewModel.connectToNode()
                }
            }) {
                Text("Connect")
            }
            .disabled(viewModel.node.isEmpty)

            Text(viewModel.isConnected ? "Connected successfully" : "Not connected")
                .foregroundColor(viewModel.isConnected ? .green : .red)
        }
        .listStyle(PlainListStyle())
        .background(Color.zephyPurp)
    }
}
