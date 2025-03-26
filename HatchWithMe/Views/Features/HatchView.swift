import SwiftUI
import StoreKit

struct HatchView: View {
    @StateObject private var viewModel = HatchViewModel.shared
    @StateObject private var storeManager = StoreKitManager.shared
    @StateObject private var adManager = AdManager.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var showingAddHatch = false
    @State private var selectedHatch: Hatch?
    @State private var showingRemoveAds = false
    @State private var showingAIAssistant = false
    @State private var showingChat = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        WelcomeCard(isEmpty: viewModel.hatches.isEmpty)
                        
                        if !viewModel.hatches.isEmpty {
                            ActiveHatchesSection(
                                hatches: viewModel.hatches,
                                hasRemovedAds: storeManager.hasRemovedAds,
                                adManager: adManager
                            )
                        }
                        
                        ActionButtons(
                            showingAddHatch: showingAddHatch,
                            showingRemoveAds: showingRemoveAds,
                            showingAIAssistant: showingAIAssistant,
                            hasRemovedAds: storeManager.hasRemovedAds,
                            isSubscribed: subscriptionManager.isSubscribed,
                            subscriptionPrice: subscriptionManager.subscriptionPrice,
                            isLoading: subscriptionManager.isLoading,
                            onAddHatch: { showingAddHatch = true },
                            onRemoveAds: { showingRemoveAds = true },
                            onAIAssistant: { showingAIAssistant = true },
                            onChat: { showingChat = true }
                        )
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                
                // Banner Ad at the bottom
                if !storeManager.hasRemovedAds {
                    VStack {
                        Spacer()
                        BannerAdView()
                            .frame(height: 50)
                            .padding(.horizontal)
                    }
                    .ignoresSafeArea(.keyboard)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Hatch With Me")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.brown)
                }
            }
            .sheet(isPresented: $showingAddHatch) {
                AddHatchView()
            }
            .sheet(isPresented: $showingRemoveAds) {
                RemoveAdsView()
            }
            .sheet(isPresented: $showingAIAssistant) {
                AIAssistantView()
            }
            .sheet(isPresented: $showingChat) {
                if let firstHatch = viewModel.hatches.first {
                    NavigationView {
                        ChatView(hatch: firstHatch)
                    }
                }
            }
        }
    }
}

