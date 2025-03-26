import SwiftUI

struct ActiveHatchesSection: View {
    let hatches: [Hatch]
    let hasRemovedAds: Bool
    let adManager: AdManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Active Hatches")
                .font(.title2)
                .bold()
            
            ForEach(hatches) { hatch in
                NavigationLink(destination: HatchDetailView(hatch: hatch)) {
                    HatchRow(hatch: hatch)
                }
                .onTapGesture {
                    if !hasRemovedAds {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootViewController = windowScene.windows.first?.rootViewController {
                            adManager.showInterstitialAd(from: rootViewController)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
} 