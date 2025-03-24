import SwiftUI
import StoreKit

struct PurchaseView: View {
    @StateObject private var storeManager = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Unlock AI Assistant")
                        .font(.title)
                        .bold()
                    
                    Text("Get expert advice for your hatches")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "brain.head.profile", text: "Expert incubation advice")
                    FeatureRow(icon: "thermometer", text: "Temperature and humidity guidance")
                    FeatureRow(icon: "arrow.triangle.2.circlepath", text: "Turning recommendations")
                    FeatureRow(icon: "lock.shield", text: "Lockdown procedures")
                    FeatureRow(icon: "lightbulb", text: "Troubleshooting help")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Purchase Button
                if let product = storeManager.products.first {
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
                            Text("Subscribe Now - \(product.displayPrice)/month")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
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
                            if storeManager.hasAIAssistant {
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
                        .foregroundColor(.blue)
                }
                .disabled(storeManager.isLoading)
                
                // Terms
                Text("Subscription automatically renews monthly. Cancel anytime.")
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

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(text)
                .font(.body)
        }
    }
} 