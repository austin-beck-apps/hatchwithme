import SwiftUI

struct RemoveAdsHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Remove All Advertisements")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Enjoy a clean, distraction-free experience")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    RemoveAdsHeaderView()
} 