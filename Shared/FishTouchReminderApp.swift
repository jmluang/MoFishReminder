//
//  FishTouchReminderApp.swift
//  Shared
//
//  Created by luang on 2021/8/3.
//

import SwiftUI
import UserNotifications

@main
struct FishTouchReminderApp : App {
    @StateObject private var settings = AuthSettings()
    @StateObject private var systheme = SystemTheme(isDark: false)
    
//    let persistenceController = PersistenceController.shared
    func getNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                settings.isAuthNotification = granted
            }
            if error != nil {
                // Handle the error here.
                print("not grant")
            }
            
            // Enable or disable features based on the authorization.
        }

    }

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            MainView()
                .environmentObject(systheme)
                .environmentObject(settings)
                .onAppear(perform: getNotificationAuthorization)
                .preferredColorScheme(systheme.isDark ? .dark : .light)
        }
    }
}
