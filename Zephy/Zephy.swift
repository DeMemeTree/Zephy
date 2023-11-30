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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RouterView()
                .foregroundColor(.white)
                .background(Color.zephyPurp)
        }
        .environmentObject(router)
        .modelContainer(sharedModelContainer)
    }
}
