import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    @StateObject private var adManager = AdManager.shared
    
    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = adManager.bannerAdUnitID
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        bannerView.load(Request())
        return bannerView
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {}
} 
