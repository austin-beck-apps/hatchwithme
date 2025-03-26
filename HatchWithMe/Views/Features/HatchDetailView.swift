import SwiftUI

class HatchDetailViewModel: ObservableObject {
    @Published var currentHatch: Hatch
    public let viewModel: HatchViewModel
    
    init(hatch: Hatch, viewModel: HatchViewModel) {
        self.currentHatch = hatch
        self.viewModel = viewModel
    }
    
    func updateName(_ newName: String) {
        currentHatch.name = newName
        viewModel.updateHatch(currentHatch)
    }
    
    func updateFertileEggs(_ count: Int) {
        // Ensure fertile eggs don't exceed total eggs
        let newCount = min(count, Int(currentHatch.totalEggs))
        currentHatch.fertileEggs = Double(newCount)
        
        // Adjust hatched and failed eggs if they would exceed fertile eggs
        if currentHatch.hatchedEggs > currentHatch.fertileEggs {
            currentHatch.hatchedEggs = currentHatch.fertileEggs
        }
        if currentHatch.failedEggs > currentHatch.fertileEggs {
            currentHatch.failedEggs = currentHatch.fertileEggs
        }
        
        viewModel.updateHatch(currentHatch)
    }
    
    func updateHatchedEggs(_ count: Int) {
        // Ensure hatched eggs don't exceed fertile eggs
        let newCount = min(count, Int(currentHatch.fertileEggs))
        currentHatch.hatchedEggs = Double(newCount)
        viewModel.updateHatch(currentHatch)
    }
    
    func updateFailedEggs(_ count: Int) {
        // Ensure failed eggs don't exceed fertile eggs
        let newCount = min(count, Int(currentHatch.fertileEggs))
        currentHatch.failedEggs = Double(newCount)
        viewModel.updateHatch(currentHatch)
    }
}

struct HatchDetailView: View {
    let hatch: Hatch
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: HatchViewModel
    @StateObject private var detailViewModel: HatchDetailViewModel
    @StateObject private var storeManager = StoreKitManager.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var showingPurchaseView = false
    @State private var showingEditSheet = false
    @State private var showingAddNote = false
    @State private var newNoteText = ""
    @State private var showingAd = false
    @ObservedObject private var adManager = AdManager.shared
    
    init(hatch: Hatch) {
        self.hatch = hatch
        let viewModel = HatchViewModel.shared
        _viewModel = StateObject(wrappedValue: viewModel)
        _detailViewModel = StateObject(wrappedValue: HatchDetailViewModel(hatch: hatch, viewModel: viewModel))
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Hatch Name", text: Binding(
                        get: { detailViewModel.currentHatch.name },
                        set: { detailViewModel.updateName($0) }
                    ))
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Spacer()
                    
                    Image(detailViewModel.currentHatch.birdType.iconName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .font(.title)
                        .foregroundColor(.brown)
                }
            }
            
            Section(header: Text("Status")) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Status")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(statusText)
                            .font(.title3)
                            .bold()
                    }
                    Spacer()
                    Image(systemName: statusIcon)
                        .font(.title)
                        .foregroundColor(statusColor)
                }
            }
            
            Section(header: Text("Timeline")) {
                TimelineRow(title: "Start Date", date: detailViewModel.currentHatch.startDate, icon: "calendar")
                TimelineRow(title: "Lockdown", date: detailViewModel.currentHatch.lockdownDate, icon: "lock.fill")
                TimelineRow(title: "Expected Hatch", date: detailViewModel.currentHatch.hatchDate, icon: "egg.fill")
            }
            
            Section(header: Text("Egg Counts")) {
                EggCounterRow(
                    title: "Fertile Eggs",
                    count: Int(detailViewModel.currentHatch.fertileEggs),
                    total: Int(detailViewModel.currentHatch.totalEggs),
                    color: .green,
                    onUpdate: detailViewModel.updateFertileEggs
                )
                
                EggCounterRow(
                    title: "Hatched Eggs",
                    count: Int(detailViewModel.currentHatch.hatchedEggs),
                    total: Int(detailViewModel.currentHatch.fertileEggs),
                    color: .blue,
                    onUpdate: detailViewModel.updateHatchedEggs
                )
                
                EggCounterRow(
                    title: "Failed Eggs",
                    count: Int(detailViewModel.currentHatch.failedEggs),
                    total: Int(detailViewModel.currentHatch.totalEggs),
                    color: .red,
                    onUpdate: detailViewModel.updateFailedEggs
                )
            }
            
            Section(header: Text("Statistics")) {
                VStack(spacing: 16) {
                    // Temperature and Humidity
                    HStack(spacing: 16) {
                        StatBox(
                            title: "Temperature",
                            value: String(format: "%.1f°C", viewModel.recommendedSettings(for: hatch.birdType).temperature),
                            color: .red,
                            icon: "thermometer"
                        )
                        
                        StatBox(
                            title: "Humidity",
                            value: String(format: "%.0f%%", viewModel.recommendedSettings(for: hatch.birdType).humidity),
                            color: .blue,
                            icon: "humidity"
                        )
                    }
                    
                    // Egg Statistics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Egg Statistics")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            EggCountBadge(
                                count: Int16(detailViewModel.currentHatch.fertileEggs),
                                total: Int16(detailViewModel.currentHatch.totalEggs),
                                color: .green,
                                label: "Fertile"
                            )
                            EggCountBadge(
                                count: Int16(detailViewModel.currentHatch.hatchedEggs),
                                total: Int16(detailViewModel.currentHatch.fertileEggs),
                                color: .blue,
                                label: "Hatched"
                            )
                            EggCountBadge(
                                count: Int16(detailViewModel.currentHatch.failedEggs),
                                total: Int16(detailViewModel.currentHatch.totalEggs),
                                color: .red,
                                label: "Failed"
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                }
            }
            
//            Section(header: Text("AI Assistant")) {
//                if subscriptionManager.isSubscribed {
//                    NavigationLink(destination: ChatView(hatch: hatch)) {
//                        HStack {
//                            Text("Ask for advice")
//                                .foregroundColor(.primary)
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(.secondary)
//                        }
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                    }
//                } else {
//                    NavigationLink(destination: AIAssistantView()) {
//                        HStack {
//                            Text("Unlock AI Assistant")
//                                .foregroundColor(.primary)
//                            Spacer()
////                            Image(systemName: "chevron.right")
////                                .foregroundColor(.secondary)
//                        }
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                    }
//                }
//            }
            
            Section(header: Text("Notes")) {
                if detailViewModel.currentHatch.notes.isEmpty {
                    Text("No notes yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(detailViewModel.currentHatch.notes) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.value)
                                .font(.body)
                            Text(note.timestamp, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Button(action: { showingAddNote = true }) {
                    Label("Add Note", systemImage: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(detailViewModel.currentHatch.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.brown)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingEditSheet = true }) {
                    Text("Edit")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingPurchaseView) {
            PurchaseView()
        }
        .sheet(isPresented: $showingEditSheet) {
            EditHatchView(hatch: detailViewModel.currentHatch)
        }
        .sheet(isPresented: $showingAddNote) {
            NavigationView {
                Form {
                    Section {
                        TextEditor(text: $newNoteText)
                            .frame(height: 100)
                    }
                }
                .navigationTitle("Add Note")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingAddNote = false
                    },
                    trailing: Button("Save") {
                        if !newNoteText.isEmpty {
                            let note = LogEntry(value: newNoteText, timestamp: Date())
                            detailViewModel.currentHatch.notes.append(note)
                            detailViewModel.viewModel.updateHatch(detailViewModel.currentHatch)
                            newNoteText = ""
                            showingAddNote = false
                        }
                    }
                    .disabled(newNoteText.isEmpty)
                )
            }
        }
    }
    
    private var statusText: String {
        if detailViewModel.currentHatch.hasHatched {
            return "Hatched"
        } else if detailViewModel.currentHatch.inLockdown {
            return "In Lockdown"
        } else {
            return "Incubating"
        }
    }
    
    private var statusIcon: String {
        if detailViewModel.currentHatch.hasHatched {
            return "checkmark.circle.fill"
        } else if detailViewModel.currentHatch.inLockdown {
            return "lock.fill"
        } else {
            return "timer"
        }
    }
    
    private var statusColor: Color {
        if detailViewModel.currentHatch.hasHatched {
            return .green
        } else if detailViewModel.currentHatch.inLockdown {
            return .orange
        } else {
            return .blue
        }
    }
    
    var progress: Double {
        if Date() >= detailViewModel.currentHatch.hatchDate {
            return 1.0
        } else if Date() < detailViewModel.currentHatch.startDate {
            return 0.0
        } else {
            let totalDays = detailViewModel.currentHatch.birdType.incubationPeriod
            let elapsedDays = Calendar.current.dateComponents([.day], from: detailViewModel.currentHatch.startDate, to: Date()).day ?? 0
            return min(Double(elapsedDays) / Double(totalDays), 1.0)
        }
    }
}

struct TimelineRow: View {
    let title: String
    let date: Date
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.brown)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(date.formatted())
                    .font(.body)
            }
            
            Spacer()
            
            if Date() >= date {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}

struct EggCounterRow: View {
    let title: String
    let count: Int
    let total: Int
    let color: Color
    let onUpdate: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("\(count)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(color)
                
                Text("of \(total)")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Stepper(value: Binding<Int>(
                    get: { count },
                    set: { onUpdate($0) }
                ), in: 0...total) {
                    Text("\(count)")
                }
                .simultaneousGesture(TapGesture().onEnded { _ in })
            }
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct LogEntry: Identifiable, Hashable, Codable {
    let id = UUID()
    let value: String
    let timestamp: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LogEntry, rhs: LogEntry) -> Bool {
        lhs.id == rhs.id
    }
}
