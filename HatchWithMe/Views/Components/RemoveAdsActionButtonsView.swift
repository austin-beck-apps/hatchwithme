import SwiftUI

struct RemoveAdsActionButtonsView: View {
    @ObservedObject var viewModel: RemoveAdsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                Task {
                    await viewModel.purchase()
                    if viewModel.hasRemovedAds {
                        dismiss()
                    }
                }
            }) {
                HStack {
                    Image(systemName: "cart.fill")
                    Text("Purchase - $0.99")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.isPurchasing)
            
            Button(action: {
                Task {
                    await viewModel.restorePurchases()
                    if viewModel.hasRemovedAds {
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
            .disabled(viewModel.isPurchasing)
        }
        .padding()
    }
}

#Preview {
    RemoveAdsActionButtonsView(viewModel: RemoveAdsViewModel())
} 