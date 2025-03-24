//
//  HatchViewModel.swift
//  HatchWithMe
//
//  Created by Austin Beck on 9/19/24.
//

import SwiftUI
import CoreData
import UserNotifications

class HatchViewModel: ObservableObject {
    static let shared = HatchViewModel(context: PersistenceController.shared.container.viewContext)
    
    @Published var hatches: [Hatch] = []
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        loadHatches()
    }
    
    private var fetchRequest: NSFetchRequest<HatchEntity> {
        let request = NSFetchRequest<HatchEntity>(entityName: "HatchEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HatchEntity.startDate, ascending: false)]
        return request
    }
    
    func loadHatches() {
        do {
            let entities = try viewContext.fetch(fetchRequest)
            hatches = entities.map { Hatch(from: $0) }
        } catch {
            print("Error loading hatches: \(error)")
        }
    }
    
    func addHatch(name: String, birdType: BirdType, startDate: Date, totalEggs: Double = 0) {
        let hatch = Hatch(name: name, birdType: birdType, startDate: startDate, totalEggs: totalEggs)
        let entity = hatch.toEntity(context: viewContext)
        viewContext.insert(entity)
        saveContext()
        loadHatches()
        
        // Schedule notifications
        scheduleLockdownNotification(for: hatch)
        scheduleHatchNotification(for: hatch)
    }
    
    func deleteHatch(_ hatch: Hatch) {
        let request = NSFetchRequest<HatchEntity>(entityName: "HatchEntity")
        request.predicate = NSPredicate(format: "id == %@", hatch.id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            entities.forEach { viewContext.delete($0) }
            saveContext()
            loadHatches()
        } catch {
            print("Error deleting hatch: \(error)")
        }
    }
    
    func updateHatch(_ hatch: Hatch) {
        let request = NSFetchRequest<HatchEntity>(entityName: "HatchEntity")
        request.predicate = NSPredicate(format: "id == %@", hatch.id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entity = entities.first {
                entity.name = hatch.name
                entity.birdType = hatch.birdType.rawValue
                entity.startDate = hatch.startDate
                entity.totalEggs = Int16(hatch.totalEggs)
                entity.fertileEggs = Int16(hatch.fertileEggs)
                entity.hatchedEggs = Int16(hatch.hatchedEggs)
                entity.failedEggs = Int16(hatch.failedEggs)
                
                if let notesData = try? JSONEncoder().encode(hatch.notes) {
                    entity.notes = String(data: notesData, encoding: .utf8)
                }
                
                saveContext()
                loadHatches()
            }
        } catch {
            print("Error updating hatch: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func recommendedSettings(for birdType: BirdType) -> (temperature: Double, humidity: Double) {
        switch birdType {
        case .chicken:
            return (37.5, 45.0)
        case .duck:
            return (37.5, 55.0)
        case .turkey:
            return (37.5, 55.0)
        case .quail:
            return (37.5, 45.0)
        case .goose:
            return (37.5, 65.0)
        }
    }
    
    // MARK: - Notification Methods
    
    private func scheduleLockdownNotification(for hatch: Hatch) {
        let content = UNMutableNotificationContent()
        content.title = "Lockdown Alert"
        content.body = "\(hatch.name) is entering lockdown today."
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: hatch.lockdownDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "lockdown-\(hatch.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling lockdown notification: \(error.localizedDescription)")
            } else {
                print("Lockdown notification scheduled for \(hatch.name).")
            }
        }
    }
    
    private func scheduleHatchNotification(for hatch: Hatch) {
        let content = UNMutableNotificationContent()
        content.title = "Hatch Day Alert"
        content.body = "\(hatch.name) is hatching today!"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: hatch.hatchDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "hatch-\(hatch.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling hatch notification: \(error.localizedDescription)")
            } else {
                print("Hatch notification scheduled for \(hatch.name).")
            }
        }
    }
}
