//
//  PokeDexApp.swift
//  PokeDex
//
//  Created by Ahmed Siddique on 05/03/2025.
//

import SwiftUI

@main
struct PokeDexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
