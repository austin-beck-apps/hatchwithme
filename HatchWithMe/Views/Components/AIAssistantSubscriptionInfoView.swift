import SwiftUI

struct AIAssistantSubscriptionInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Subscription Details")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(title: "Title", value: "AI Assistant Premium Access")
                InfoRow(title: "Price", value: "$2.99 per month")
                InfoRow(title: "Duration", value: "Monthly subscription")
                InfoRow(title: "Billing", value: "Charged monthly to your Apple ID")
                InfoRow(title: "Renewal", value: "Auto-renews unless canceled")
            }
            
            Text("Your subscription will automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and turn off auto-renewal in your Apple ID account settings.")
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

#Preview {
    AIAssistantSubscriptionInfoView()
} 