import SwiftUI

struct RemoveAdsPurchaseInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Purchase Details")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(title: "Price", value: "$0.99 USD")
                InfoRow(title: "Duration", value: "Lifetime access - never expires")
                InfoRow(title: "Purchase Name", value: "Remove All Advertisements")
                InfoRow(title: "Restore", value: "Available across all devices")
            }
            
            Text("This purchase will permanently remove all advertisements from the app. You can restore this purchase on any device using the same Apple ID.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
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
                .fontWeight(.medium)
        }
    }
}

#Preview {
    RemoveAdsPurchaseInfoView()
} 