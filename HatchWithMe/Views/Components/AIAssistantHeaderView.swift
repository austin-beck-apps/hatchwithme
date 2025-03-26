import SwiftUI

struct AIAssistantHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("AI Assistant")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Get expert guidance for your egg hatching journey")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    AIAssistantHeaderView()
} 