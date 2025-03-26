import SwiftUI

struct WelcomeCard: View {
    let isEmpty: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isEmpty {
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
    }
} 