//
//  FishTouchReminderApp.swift
//  Shared
//
//  Created by luang on 2021/8/3.
//

import SwiftUI

@main
struct FishTouchReminderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
