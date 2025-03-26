import SwiftUI

struct AIAssistantFeaturesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Features")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(icon: "message.fill", text: "24/7 Expert Guidance")
                FeatureRow(icon: "checkmark.circle.fill", text: "Personalized Advice")
                FeatureRow(icon: "checkmark.circle.fill", text: "Species-Specific Information")
                FeatureRow(icon: "checkmark.circle.fill", text: "Troubleshooting Support")
                FeatureRow(icon: "checkmark.circle.fill", text: "Best Practices")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    AIAssistantFeaturesView()
} 
