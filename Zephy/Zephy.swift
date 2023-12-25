//
//  ZephyApp.swift
//  Zephy
//
//

import SwiftUI
import SwiftData

@main
struct ZephyApp: App {
    @StateObject var router = Router()
    @StateObject var timeKeeper = TimeKeeper()
    
    var body: some Scene {
        WindowGroup {
            RouterView()
                .foregroundColor(.white)
                .background(Color.zephyPurp)
                .preferredColorScheme(.dark)
                .environment(\.colorScheme, .dark)
                .environmentObject(router)
                .environmentObject(timeKeeper)
        }
    }
}
