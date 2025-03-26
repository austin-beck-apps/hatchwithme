import SwiftUI

class RemoveAdsViewModel: ObservableObject {
    @Published var isPurchasing = false
    @Published var hasRemovedAds = false
    
    func purchase() async {
        isPurchasing = true
        // Implement purchase logic
        hasRemovedAds = true
        isPurchasing = false
    }
    
    func restorePurchases() async {
        isPurchasing = true
        // Implement restore logic
        hasRemovedAds = true
        isPurchasing = false
    }
}

struct RemoveAdsView: View {
    @StateObject private var viewModel = RemoveAdsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    RemoveAdsHeaderView()
                    RemoveAdsFeaturesView()
                    RemoveAdsPurchaseInfoView()
                    RemoveAdsLegalLinksView()
                    RemoveAdsActionButtonsView(viewModel: viewModel)
                }
                .padding()
            }
            .navigationTitle("Remove Ads")
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
    RemoveAdsView()
} 