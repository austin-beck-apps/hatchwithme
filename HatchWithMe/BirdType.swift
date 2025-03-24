import Foundation

enum BirdType: String, CaseIterable, Identifiable, Codable {
    case chicken
    case duck
    case turkey
    case quail
    case goose
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .chicken: return "Chicken"
        case .duck: return "Duck"
        case .turkey: return "Turkey"
        case .quail: return "Quail"
        case .goose: return "Goose"
        }
    }
    
    var incubationPeriod: Double {
        switch self {
        case .chicken: return 21
        case .duck: return 28
        case .turkey: return 28
        case .quail: return 17
        case .goose: return 30
        }
    }
    
    var iconName: String {
        switch self {
        case .chicken: return "chicken.icon"
        case .duck: return "duck.icon"
        case .turkey: return "turkey.icon"
        case .quail: return "quail.icon"
        case .goose: return "goose.icon"
        }
    }
    
    var description: String {
        switch self {
        case .chicken: return "Standard chicken eggs"
        case .duck: return "Duck eggs"
        case .turkey: return "Turkey eggs"
        case .quail: return "Quail eggs"
        case .goose: return "Goose eggs"
        }
    }
    
    var lockdownDaysBeforeHatch: Int {
        switch self {
        case .chicken: return 3
        case .duck: return 3
        case .turkey: return 3
        case .quail: return 2
        case .goose: return 3
        }
    }
    
    // Incubation parameters
    var incubationTemperature: Double {
        switch self {
        case .chicken: return 99.5
        case .duck: return 99.5
        case .turkey: return 99.5
        case .quail: return 99.5
        case .goose: return 99.5
        }
    }
    
    var incubationHumidity: Double {
        switch self {
        case .chicken: return 50
        case .duck: return 55
        case .turkey: return 50
        case .quail: return 45
        case .goose: return 55
        }
    }
    
    var turnFrequency: Int {
        switch self {
        case .chicken: return 3
        case .duck: return 3
        case .turkey: return 3
        case .quail: return 3
        case .goose: return 3
        }
    }
    
    var lockdownDays: Int {
        switch self {
        case .chicken: return 3
        case .duck: return 3
        case .turkey: return 3
        case .quail: return 2
        case .goose: return 3
        }
    }
    
    var lockdownHumidity: Double {
        switch self {
        case .chicken: return 65
        case .duck: return 70
        case .turkey: return 65
        case .quail: return 60
        case .goose: return 70
        }
    }
    
    var candlingDays: Int {
        switch self {
        case .chicken: return 7
        case .duck: return 7
        case .turkey: return 7
        case .quail: return 5
        case .goose: return 7
        }
    }
} 
