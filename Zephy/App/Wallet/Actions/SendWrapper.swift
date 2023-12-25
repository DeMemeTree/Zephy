//
//  SendWrapper.swift
//  Zephy
//
//
import Combine
import SwiftUI

struct SendWrapper: View {
    static let pipe = PassthroughSubject<Int, Never>()
    @EnvironmentObject var router: Router
    
    @State var selectedView: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedView == 0 {
                    SendView()
                } else {
                    SwapView()
                }
            }
            .navigationTitle("Transfer Asset")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(selectedView == 1 ? "Back" : "Cancel", action: {
                if selectedView == 1 {
                    selectedView = 0
                } else {
                    router.changeRoot(to: .wallet)
                }
            }))
            .onReceive(SendWrapper.pipe, perform: { newVal in
                withAnimation {
                    selectedView = newVal
                }
            })
        }
    }
}
