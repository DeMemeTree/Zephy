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
                    Text("Please include the port (http://127.0.0.1:17767)")
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
                Text("Try connection")
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.connectedState == .connected ? Color.green : Color.red, lineWidth: 2)
                    )
            }
            .disabled(viewModel.node.isEmpty)

            Text(viewModel.connectedState == .connected
                 ? "Connected successfully" :
                    (viewModel.connectedState == .loading ? "Loading..." : "Not connected"))
            .foregroundColor(viewModel.connectedState == .connected ? .green
                             : (viewModel.connectedState == .loading ? .yellow : .red))
            
            nodeListLogic()
            Rectangle()
                .frame(height: 40)
                .foregroundColor(.clear)
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
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
        case .loading:
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        case .found(let fetchedNodes):
            ForEach(fetchedNodes, id: \.urlPort) { node in
                row(node: node)
            }
        }
    }
    
    private func row(node: NodeService.Node) -> some View {
        Button {
            viewModel.node = "\(node.port == 443 ? "https" : "http")://\(node.url):\(node.port)"
            Task {
                await viewModel.connectToNode()
            }
        } label: {
            VStack(alignment: .leading) {
                Text(node.name)
                    .font(.headline)
                Text("Height: \(node.height)")
                    .font(.caption)
            }
        }
        .contentShape(Rectangle())
    }
}
