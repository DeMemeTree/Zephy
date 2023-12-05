//
//  ConnectedView.swift
//  Zephy
//
//
import SwiftUI

struct ConnectedView: View {
    enum Status {
        case connected
        case disconnected
        case connecting
    }
    
    @State private var status: Status = .connecting
    @State private var canRetry: Bool = true
    @State private var retryCooldown: TimeInterval = 10
    @State private var showToast: Bool = false
    @State private var canShowToast = false
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                if showToast {
                    toastView
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: showToast)
                }
            }
            .background(Color.zephyPurp)
        }
        .padding(.top, 88)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                canShowToast = true
                if NodeService.currentNode != nil,
                   NodeService.isNodeConnected == false {
                    handleStatusChange(status: .disconnected)
                }
            })
        }
        .onChange(of: status, perform: handleStatusChange)
//        .onReceive(DataPipe.shared.backendConnected, perform: { connectedValue in
//            guard canShowToast else { return }
//            handleStatusChange(status: connectedValue ? .connected : .disconnected)
//        })
    }
    
    private var toastView: some View {
        HStack {
            Image(systemName: statusSystemIconName)
                .foregroundColor(statusColor)
            VStack(alignment: .leading, spacing: 0) {
                Text(statusText)
                    .kerning(0.25)
                    .foregroundColor(statusColor)
                Text(statusFullText)
                    .kerning(0.25)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .lineSpacing(2)
                    .padding(.top, 4)
            }
            Spacer()
            if status == .disconnected && canRetry {
                retryButton
            }
        }
        .padding()
        .background(statusBackgroundColor)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
    
    private var statusText: String {
        switch status {
        case .connected: return "Connected"
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting..."
        }
    }
    
    private var statusFullText: String {
        switch status {
        case .connected: return "You're connected to our servers."
        case .disconnected: return "Please check your network connection and retry."
        case .connecting: return "Trying to reconnect..."
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .connected: return .green
        case .disconnected: return .red
        case .connecting: return .orange
        }
    }
    
    private var statusBackgroundColor: Color {
        .zephyPurp
    }
    
    private var statusSystemIconName: String {
        switch status {
        case .connected: return "checkmark.circle.fill"
        case .disconnected: return "xmark.octagon.fill"
        case .connecting: return "arrow.triangle.2.circlepath.circle.fill"
        }
    }
    
    private var retryButton: some View {
        Button(action: retryConnection) {
            Label("Retry", systemImage: "arrow.clockwise")
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
        }
        .transition(.scale)
    }
    
    private func retryConnection() {
        guard canRetry else { return }
        canRetry = false
        status = .connecting
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            if status != .connected {
                status = .disconnected
            }
        })
        
        startCooldownTimer()
    }
    
    private func startCooldownTimer() {
        retryCooldown = 10
        canRetry = false
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.retryCooldown > 0 {
                self.retryCooldown -= 1
            } else {
                timer.invalidate()
                self.canRetry = true
                self.retryCooldown = 10
            }
        }
    }
    
    private func handleStatusChange(status: Status) {
        self.status = status
        if status == .connected {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeIn) {
                    self.showToast = false
                }
            }
        } else {
            withAnimation(.easeOut) {
                self.showToast = true
            }
        }
    }
}
