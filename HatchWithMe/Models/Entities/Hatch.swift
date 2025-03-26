import Foundation
import CoreData
import SwiftUI

class Hatch: ObservableObject, Identifiable {
    let id: UUID
    @Published var name: String
    @Published var birdType: BirdType
    @Published var startDate: Date
    @Published var totalEggs: Double
    @Published var fertileEggs: Double
    @Published var hatchedEggs: Double
    @Published var failedEggs: Double
    @Published var notes: [LogEntry]
    
    var lockdownDate: Date {
        startDate.addingTimeInterval(birdType.incubationPeriod * 0.7 * 24 * 60 * 60)
    }
    
    var hatchDate: Date {
        startDate.addingTimeInterval(birdType.incubationPeriod * 24 * 60 * 60)
    }
    
    var inLockdown: Bool {
        Date() >= lockdownDate && Date() < hatchDate
    }
    
    var hasHatched: Bool {
        Date() >= hatchDate
    }
    
    var statusText: String {
        if hasHatched {
            return "Hatched"
        } else if inLockdown {
            return "In Lockdown"
        } else {
            return "Incubating"
        }
    }
    
    var statusColor: Color {
        if hasHatched {
            return .green
        } else if inLockdown {
            return .orange
        } else {
            return .blue
        }
    }
    
    init(name: String, birdType: BirdType, startDate: Date, totalEggs: Double = 0) {
        self.id = UUID()
        self.name = name
        self.birdType = birdType
        self.startDate = startDate
        self.totalEggs = totalEggs
        self.fertileEggs = 0
        self.hatchedEggs = 0
        self.failedEggs = 0
        self.notes = []
    }
    
    init(from entity: HatchEntity) {
        self.id = entity.id
        self.name = entity.name
        self.birdType = BirdType(rawValue: entity.birdType) ?? .chicken
        self.startDate = entity.startDate
        self.totalEggs = Double(entity.totalEggs)
        self.fertileEggs = Double(entity.fertileEggs)
        self.hatchedEggs = Double(entity.hatchedEggs)
        self.failedEggs = Double(entity.failedEggs)
        
        // Convert JSON string back to notes array
        if let notesString = entity.notes,
           let notesData = notesString.data(using: String.Encoding.utf8),
           let decodedNotes = try? JSONDecoder().decode([LogEntry].self, from: notesData) {
            self.notes = decodedNotes
        } else {
            self.notes = []
        }
    }
    
    func toEntity(context: NSManagedObjectContext) -> HatchEntity {
        let entity = HatchEntity(context: context)
        entity.id = id
        entity.name = name
        entity.birdType = birdType.rawValue
        entity.startDate = startDate
        entity.totalEggs = Int16(totalEggs)
        entity.fertileEggs = Int16(fertileEggs)
        entity.hatchedEggs = Int16(hatchedEggs)
        entity.failedEggs = Int16(failedEggs)
        
        // Convert notes array to JSON string
        if let notesData = try? JSONEncoder().encode(notes) {
            entity.notes = String(data: notesData, encoding: String.Encoding.utf8)
        }
        
        return entity
    }
    
    func addLog(_ text: String) {
        let entry = LogEntry(value: text, timestamp: Date())
        notes.append(entry)
    }
} 
