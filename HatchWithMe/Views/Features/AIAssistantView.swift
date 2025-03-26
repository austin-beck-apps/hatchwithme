import SwiftUI

class AIAssistantViewModel: ObservableObject {
    @Published var isSubscribing = false
    @Published var isSubscribed = false
    
    func subscribe() async {
        isSubscribing = true
        // Implement subscription logic
        isSubscribed = true
        isSubscribing = false
    }
    
    func restorePurchases() async {
        isSubscribing = true
        // Implement restore logic
        isSubscribed = true
        isSubscribing = false
    }
}

struct AIAssistantView: View {
    @StateObject private var viewModel = AIAssistantViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    AIAssistantHeaderView()
                    AIAssistantFeaturesView()
                    AIAssistantSubscriptionInfoView()
                    AIAssistantLegalLinksView()
                    AIAssistantActionButtonsView(viewModel: viewModel)
                }
                .padding()
            }
            .navigationTitle("AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AIAssistantView()
} 