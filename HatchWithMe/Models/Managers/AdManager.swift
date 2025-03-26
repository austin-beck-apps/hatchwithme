import GoogleMobileAds
import SwiftUI

class AdManager: ObservableObject {
    static let shared = AdManager()
    
    @Published var interstitialAd: InterstitialAd?
    @Published var bannerAd: BannerView?
    @Published var hasRemovedAds = false
    
    private let interstitialAdUnitID = "ca-app-pub-3123485026939516/9346105035"
    public let bannerAdUnitID = "ca-app-pub-3123485026939516/5390548154"
    
    private init() {
        initialize()
        checkAdsRemoved()
    }
    
    func initialize() {
        MobileAds.shared.start(completionHandler: nil)
        loadInterstitialAd()
    }
    
    func loadInterstitialAd() {
        let request = Request()
        InterstitialAd.load(with: interstitialAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
        }
    }
    
    func loadBannerAd() {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = bannerAdUnitID
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        bannerView.load(Request())
        self.bannerAd = bannerView
    }
    
    func showInterstitialAd(from viewController: UIViewController) {
        guard let interstitialAd = interstitialAd else {
            print("Ad wasn't ready")
            return
        }
        
        interstitialAd.present(from: viewController)
        loadInterstitialAd()
    }
    
    func removeAds() {
        hasRemovedAds = true
        UserDefaults.standard.set(true, forKey: "hasRemovedAds")
    }
    
    private func checkAdsRemoved() {
        hasRemovedAds = UserDefaults.standard.bool(forKey: "hasRemovedAds")
    }
} 
