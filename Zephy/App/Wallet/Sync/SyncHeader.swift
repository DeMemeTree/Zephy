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
        var synchronized: Bool
    }
    
    @EnvironmentObject var router: Router
    @State var blockData: BlockData
    static var isConnected = CurrentValueSubject<Bool, Never>(false)
    static let syncRx = CurrentValueSubject<BlockData, Never>(BlockData(currentBlock: 0,
                                                                        targetBlock: 1,
                                                                        synchronized: false))
    
    @State var connected = false
    
    init() {
        self.blockData = SyncHeader.syncRx.value
    }

    private var progress: Double {
        guard blockData.targetBlock != 0 else { return 0.3 }
        var retVal = Double(blockData.currentBlock) / Double(blockData.targetBlock)
        if retVal >= 0.95 && retVal < 1 {
            retVal = 0.95
        }
        return retVal
    }

    var body: some View {
        HStack {
            Image(systemName: blockData.synchronized ? "point.3.filled.connected.trianglepath.dotted" : "point.3.connected.trianglepath.dotted")
                .foregroundColor(blockData.synchronized == false ? .yellow : (connected ? .green : .red))
            
            if blockData.currentBlock != 0 {
                if progress < 1 {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .id(blockData.currentBlock)
                } else {
                    Text("Block: \(blockData.currentBlock)")
                        .frame(maxWidth: .infinity)
                }
            } else {
                Spacer()
            }
            
            Button {
                router.changeRoot(to: .settings)
            } label: {
                Image(systemName: "gearshape")
            }
        }
        .onAppear {
            withAnimation {
                connected = SyncHeader.isConnected.value
            }
        }
        .onReceive(SyncHeader.isConnected, perform: { val in
            withAnimation {
                connected = val
            }
        })
        .onReceive(SyncHeader.syncRx) { newData in
            var newData = newData
            withAnimation {
                if newData.currentBlock != newData.targetBlock {
                    newData.synchronized = false
                } else {
                    newData.synchronized = true
                }
                self.blockData = newData
            }
        }
    }
}
