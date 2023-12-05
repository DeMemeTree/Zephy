//
//  NodesView.swift
//  Zephy
//
//
import SwiftUI

struct NodesView: View {
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
            
            nodeListLogic()
        }
        .listStyle(PlainListStyle())
        .background(Color.zephyPurp)
    }
    
    @ViewBuilder
    private func nodeListLogic() -> some View {
        switch viewModel.state {
        case .needsFetch:
            Button {
                viewModel.fetch()
            } label: {
                Text("Fetch node list")
            }
        case .loading:
            ProgressView()
        case .found(let fetchedNodes):
            ForEach(fetchedNodes, id: \.url) { node in
                row(node: node)
            }
        }
    }
    
    private func row(node: NodeService.Node) -> some View {
        VStack(alignment: .leading) {
            Text(node.name)
                .font(.headline)
            Text("Height: \(node.height)")
                .font(.caption)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.node = "\(node.port == 443 ? "https" : "http")://\(node.url):\(node.port)"
        }
    }
}
