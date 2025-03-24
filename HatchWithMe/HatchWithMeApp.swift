//
//  HatchWithMeApp.swift
//  HatchWithMe
//
//  Created by Austin Beck on 9/19/24.
//

import SwiftUI
import UserNotifications
import GoogleMobileAds

@main
struct HatchWithMeApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        // Configure AdMob
        let request = Request()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        MobileAds.shared.start(completionHandler: nil)
        
        // Request notification permissions when the app launches
        requestNotificationPermissions()
    }
    
    var body: some Scene {
        WindowGroup {
            HatchView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    func requestNotificationPermissions() {
        // Ask the user for permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
}
