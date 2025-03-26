import SwiftUI

struct ActionButtons: View {
    let showingAddHatch: Bool
    let showingRemoveAds: Bool
    let showingAIAssistant: Bool
    let hasRemovedAds: Bool
    let isSubscribed: Bool
    let subscriptionPrice: String
    let isLoading: Bool
    
    let onAddHatch: () -> Void
    let onRemoveAds: () -> Void
    let onAIAssistant: () -> Void
    let onChat: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Add New Hatch Button
            Button(action: onAddHatch) {
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
            
            // AI Assistant Button
            if isSubscribed {
                Button(action: onChat) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                        Text("AI Assistant")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .foregroundColor(.purple)
                    .cornerRadius(15)
                }
            } else {
                Button(action: onAIAssistant) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                        Text("Unlock AI Assistant")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .foregroundColor(.purple)
                    .cornerRadius(15)
                }
            }
            
            // Remove Ads Button
            if !hasRemovedAds {
                Button(action: onRemoveAds) {
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
    }
} 