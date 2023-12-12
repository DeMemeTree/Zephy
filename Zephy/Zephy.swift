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
    var body: some Scene {
        WindowGroup {
            RouterView()
                .foregroundColor(.white)
                .background(Color.zephyPurp)
                .preferredColorScheme(.dark)
                .environment(\.colorScheme, .dark)
                .environmentObject(router)
        }
    }
}
