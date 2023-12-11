//
//  SyncHeader.swift
//  Zephy
//
//
import Combine
import SwiftUI

struct SyncHeader: View {
    struct BlockData {
        let currentBlock: UInt64
        let targetBlock: UInt64
        let synchronized: Bool
    }
    
    @EnvironmentObject var router: Router
    @State var blockData: BlockData
    static var isConnected: Bool = false
    static let syncRx = CurrentValueSubject<BlockData, Never>(BlockData(currentBlock: 0,
                                                                        targetBlock: 0,
                                                                        synchronized: false))
    
    init() {
        self.blockData = SyncHeader.syncRx.value
    }

    private var progress: Double {
        guard blockData.targetBlock != 0 else { return 0.3 }
        return Double(blockData.currentBlock / blockData.targetBlock)
    }

    var body: some View {
        HStack {
            Image(systemName: blockData.synchronized ? "point.3.filled.connected.trianglepath.dotted" : "point.3.connected.trianglepath.dotted")
                .foregroundColor(blockData.synchronized == false ? .yellow : (SyncHeader.isConnected ? .green : .red))
            
            if progress < 1 {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
            } else {
                Text("Block: \(blockData.currentBlock)")
                    .frame(maxWidth: .infinity)
            }
            
            Button {
                router.changeRoot(to: .settings)
            } label: {
                Image(systemName: "gearshape")
            }
        }
        .onReceive(SyncHeader.syncRx) { newData in
            withAnimation {
                self.blockData = newData
            }
        }
    }
}