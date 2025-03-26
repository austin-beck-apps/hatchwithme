import SwiftUI

struct AIAssistantActionButtonsView: View {
    @ObservedObject var viewModel: AIAssistantViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                Task {
                    await viewModel.subscribe()
                    if viewModel.isSubscribed {
                        dismiss()
                    }
                }
            }) {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Subscribe - $2.99/month")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.isSubscribing)
            
            Button(action: {
                Task {
                    await viewModel.restorePurchases()
                    if viewModel.isSubscribed {
                        dismiss()
                    }
                }
            }) {
                Text("Restore Purchases")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
            }
            .disabled(viewModel.isSubscribing)
        }
        .padding()
    }
}

#Preview {
    AIAssistantActionButtonsView(viewModel: AIAssistantViewModel())
} 