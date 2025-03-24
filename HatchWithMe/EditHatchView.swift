import SwiftUI

struct EditHatchView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var hatch: Hatch
    @State private var name: String
    @State private var totalEggs: Int
    @State private var fertileEggs: Int
    @State private var hatchedEggs: Int
    @State private var failedEggs: Int
    @State private var startDate: Date
    
    init(hatch: Hatch) {
        self.hatch = hatch
        _name = State(initialValue: hatch.name)
        _totalEggs = State(initialValue: Int(hatch.totalEggs))
        _fertileEggs = State(initialValue: Int(hatch.fertileEggs))
        _hatchedEggs = State(initialValue: Int(hatch.hatchedEggs))
        _failedEggs = State(initialValue: Int(hatch.failedEggs))
        _startDate = State(initialValue: hatch.startDate)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Hatch Name", text: $name)
                    
                    Stepper("Total Eggs: \(totalEggs)", value: $totalEggs, in: 0...100)
                    Stepper("Fertile Eggs: \(fertileEggs)", value: $fertileEggs, in: 0...totalEggs)
                    Stepper("Hatched Eggs: \(hatchedEggs)", value: $hatchedEggs, in: 0...fertileEggs)
                    Stepper("Failed Eggs: \(failedEggs)", value: $failedEggs, in: 0...fertileEggs)
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    
                    HStack {
                        Text("Lockdown Date")
                        Spacer()
                        Text(hatch.lockdownDate, style: .date)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Expected Hatch")
                        Spacer()
                        Text(hatch.hatchDate, style: .date)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Edit Hatch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        // Update the hatch with new values
        hatch.name = name
        hatch.totalEggs = Double(totalEggs)
        hatch.fertileEggs = Double(fertileEggs)
        hatch.hatchedEggs = Double(hatchedEggs)
        hatch.failedEggs = Double(failedEggs)
        hatch.startDate = startDate
        
        // Save to Core Data
        try? PersistenceController.shared.container.viewContext.save()
        
        dismiss()
    }
} 