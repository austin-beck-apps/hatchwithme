import SwiftUI

struct RemoveAdsLegalLinksView: View {
    var body: some View {
        VStack(spacing: 12) {
            Link("Terms of Use", destination: URL(string: "https://hatchwithme.com/terms")!)
                .font(.subheadline)
            
            Link("Privacy Policy", destination: URL(string: "https://hatchwithme.com/privacy")!)
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    RemoveAdsLegalLinksView()
} 