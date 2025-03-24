import SwiftUI

struct AddHatchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = HatchViewModel.shared
    
    @State private var name = ""
    @State private var selectedBirdType: BirdType = .chicken
    @State private var startDate = Date()
    @State private var totalEggs: Int16 = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    BirdTypeSelectionCard(selectedBirdType: $selectedBirdType)
                    
                    HatchDetailsCard(
                        name: $name,
                        startDate: $startDate,
                        totalEggs: $totalEggs
                    )
                    
                    IncubationInfoCard(
                        birdType: selectedBirdType,
                        startDate: startDate
                    )
                    
                    StartButton(
                        name: name,
                        birdType: selectedBirdType,
                        startDate: startDate,
                        totalEggs: totalEggs,
                        viewModel: viewModel,
                        dismiss: dismiss
                    )
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
    }
}

struct BirdTypeSelectionCard: View {
    @Binding var selectedBirdType: BirdType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Bird Type")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(BirdType.allCases) { birdType in
                        BirdTypeButton(
                            birdType: birdType,
                            isSelected: selectedBirdType == birdType,
                            action: { selectedBirdType = birdType }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct HatchDetailsCard: View {
    @Binding var name: String
    @Binding var startDate: Date
    @Binding var totalEggs: Int16
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hatch Details")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Hatch Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter a name for your hatch", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Start Date")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Number of Eggs")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("\(totalEggs)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.brown)
                    
                    Spacer()
                    
                    Stepper("", value: $totalEggs, in: 0...100)
                        .labelsHidden()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct IncubationInfoCard: View {
    let birdType: BirdType
    let startDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Incubation Information")
                .font(.headline)
                .foregroundColor(.secondary)
            
            InfoRow(title: "Incubation Period", value: "\(birdType.incubationPeriod) days")
            InfoRow(title: "Lockdown Period", value: "\(birdType.lockdownDaysBeforeHatch) days before hatch")
            InfoRow(title: "Expected Hatch", value: calculateHatchDate().formatted(date: .long, time: .omitted))
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func calculateHatchDate() -> Date {
        Calendar.current.date(byAdding: .day, value: Int(birdType.incubationPeriod), to: startDate) ?? startDate
    }
}

struct StartButton: View {
    let name: String
    let birdType: BirdType
    let startDate: Date
    let totalEggs: Int16
    let viewModel: HatchViewModel
    let dismiss: DismissAction
    
    var body: some View {
        Button(action: {
            viewModel.addHatch(
                name: name,
                birdType: birdType,
                startDate: startDate,
                totalEggs: Double(totalEggs)
            )
            dismiss()
        }) {
            HStack {
                Image(systemName: "egg.fill")
                Text("Start Hatch")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.brown.opacity(0.1))
            .foregroundColor(.brown)
            .cornerRadius(15)
        }
        .disabled(name.isEmpty)
    }
}

// MARK: - Supporting Views
struct BirdTypeButton: View {
    let birdType: BirdType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(birdType.iconName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .font(.title)
                Text(birdType.rawValue.capitalized)
                    .font(.caption)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? Color.brown.opacity(0.1) : Color(.systemBackground))
            .foregroundColor(isSelected ? .brown : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.brown : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}
