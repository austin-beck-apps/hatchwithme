import SwiftUI

struct RemoveAdsFeaturesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Benefits")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(icon: "checkmark.circle.fill", text: "Remove all banner advertisements")
                FeatureRow(icon: "checkmark.circle.fill", text: "Remove all interstitial advertisements")
                FeatureRow(icon: "checkmark.circle.fill", text: "Clean, distraction-free interface")
                FeatureRow(icon: "checkmark.circle.fill", text: "One-time purchase, lifetime access")
                FeatureRow(icon: "checkmark.circle.fill", text: "Restore purchase on any device")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    RemoveAdsFeaturesView()
} 
