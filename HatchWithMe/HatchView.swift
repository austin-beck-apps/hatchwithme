import SwiftUI

struct HatchView: View {
    @StateObject private var viewModel = HatchViewModel.shared
    @StateObject private var storeManager = StoreKitManager.shared
    @StateObject private var adManager = AdManager.shared
    @State private var showingAddHatch = false
    @State private var selectedHatch: Hatch?
    @State private var showingRemoveAds = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Welcome Card
                        VStack(alignment: .leading, spacing: 8) {
                            if viewModel.hatches.isEmpty {
                                Text("Welcome to")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                
                                Text("Hatch With Me")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.brown)
                                
                                Text("Your personal egg incubation companion. Track your hatch progress, get expert advice, and ensure successful hatches every time. Start a new hatch to get started!")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(4)
                            } else {
                                Text("My Hatches")
                                    .font(.title)
                                    .bold()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Active Hatches
                        if !viewModel.hatches.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Active Hatches")
                                    .font(.title2)
                                    .bold()
                                
                                ForEach(viewModel.hatches) { hatch in
                                    NavigationLink(destination: HatchDetailView(hatch: hatch)) {
                                        HatchRow(hatch: hatch)
                                    }
                                    .onTapGesture {
                                        if !storeManager.hasRemovedAds {
                                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                               let rootViewController = windowScene.windows.first?.rootViewController {
                                                adManager.showInterstitialAd(from: rootViewController)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        
                        // Add New Hatch Button
                        Button(action: {
//                            if !storeManager.hasRemovedAds {
//                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                                   let rootViewController = windowScene.windows.first?.rootViewController {
//                                    adManager.showInterstitialAd(from: rootViewController)
//                                }
//                            }
                            showingAddHatch = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("Start New Hatch")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(15)
                        }
                        
                        // Remove Ads Button
                        if !storeManager.hasRemovedAds {
                            Button(action: { showingRemoveAds = true }) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                    Text("Remove Ads")
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .cornerRadius(15)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                
                // Banner Ad at the bottom
                if !storeManager.hasRemovedAds {
                    VStack {
                        Spacer()
                        BannerAdView()
                            .frame(height: 50)
                            .padding(.horizontal)
                    }
                    .ignoresSafeArea(.keyboard)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Hatch With Me")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.brown)
                }
            }
            .sheet(isPresented: $showingAddHatch) {
                AddHatchView()
            }
            .sheet(isPresented: $showingRemoveAds) {
                RemoveAdsView()
            }
        }
    }
}

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

struct EggCountBadge: View {
    let count: Int16
    let total: Int16
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(count)")
                .font(.subheadline)
                .bold()
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct RemoveAdsView: View {
    @StateObject private var storeManager = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("Remove Ads")
                        .font(.title)
                        .bold()
                    
                    Text("Enjoy an ad-free experience")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "checkmark.circle.fill", text: "No more interstitial ads")
                    FeatureRow(icon: "checkmark.circle.fill", text: "No more banner ads")
                    FeatureRow(icon: "checkmark.circle.fill", text: "Clean, distraction-free interface")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Purchase Button
                if let product = storeManager.products.first(where: { $0.id == "com.hatchwithme.removeads" }) {
                    Button(action: {
                        Task {
                            do {
                                try await storeManager.purchase(product)
                                dismiss()
                            } catch {
                                errorMessage = error.localizedDescription
                                showError = true
                            }
                        }
                    }) {
                        if storeManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Remove Ads - \(product.displayPrice)")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .disabled(storeManager.isLoading)
                }
                
                // Restore Button
                Button(action: {
                    Task {
                        do {
                            try await storeManager.restorePurchases()
                            if storeManager.hasRemovedAds {
                                dismiss()
                            }
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }
                }) {
                    Text("Restore Purchases")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
                .disabled(storeManager.isLoading)
                
                // Terms
                Text("One-time purchase. Restore available.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            .navigationBarItems(trailing: Button("Close") { dismiss() })
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
} 
