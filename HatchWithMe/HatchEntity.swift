import Foundation
import CoreData

@objc(HatchEntity)
public class HatchEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var birdType: String
    @NSManaged public var startDate: Date
    @NSManaged public var totalEggs: Int16
    @NSManaged public var fertileEggs: Int16
    @NSManaged public var hatchedEggs: Int16
    @NSManaged public var failedEggs: Int16
    @NSManaged public var notes: String?
} 