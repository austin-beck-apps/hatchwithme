import SwiftUI

struct HatchRow: View {
    let hatch: Hatch
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(hatch.name)
                        .font(.headline)
                    Text(hatch.birdType.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(hatch.birdType.iconName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .font(.title2)
                    .foregroundColor(.brown)
            }
            
            // Progress Bar
            ProgressView(value: progress)
                .tint(progressColor)
            
            // Dates and Status
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Start: \(hatch.startDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Hatch: \(hatch.hatchDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Status Badge
                HStack(spacing: 4) {
                    Image(systemName: statusIcon)
                    Text(statusText)
                }
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.1))
                .foregroundColor(statusColor)
                .cornerRadius(8)
            }
            
            // Egg Counts
            if hatch.totalEggs > 0 {
                HStack(spacing: 16) {
                    EggCountBadge(count: Int16(hatch.fertileEggs), total: Int16(hatch.totalEggs), color: .green, label: "Fertile")
                    EggCountBadge(count: Int16(hatch.hatchedEggs), total: Int16(hatch.fertileEggs), color: .blue, label: "Hatched")
                    EggCountBadge(count: Int16(hatch.failedEggs), total: Int16(hatch.fertileEggs), color: .red, label: "Failed")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private var progress: Double {
        if Date() >= hatch.hatchDate {
            return 1.0
        } else if Date() < hatch.startDate {
            return 0.0
        } else {
            let totalDays = hatch.birdType.incubationPeriod
            let elapsedDays = Calendar.current.dateComponents([.day], from: hatch.startDate, to: Date()).day ?? 0
            return min(Double(elapsedDays) / Double(totalDays), 1.0)
        }
    }
    
    private var statusText: String {
        if hatch.hasHatched {
            return "Hatched"
        } else if hatch.inLockdown {
            return "Lockdown"
        } else {
            return "Incubating"
        }
    }
    
    private var statusIcon: String {
        if hatch.hasHatched {
            return "checkmark.circle.fill"
        } else if hatch.inLockdown {
            return "lock.fill"
        } else {
            return "timer"
        }
    }
    
    private var statusColor: Color {
        if hatch.hasHatched {
            return .green
        } else if hatch.inLockdown {
            return .orange
        } else {
            return .blue
        }
    }
    
    private var progressColor: Color {
        if hatch.hasHatched {
            return .green
        } else if hatch.inLockdown {
            return .orange
        } else {
            return .blue
        }
    }
} 