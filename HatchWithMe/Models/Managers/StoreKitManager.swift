import StoreKit
import SwiftUI

@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var subscriptionStatus: SubscriptionStatus = .unknown
    
    private let productIDs = [
        "com.hatchwithme.aiassistant.subscription",
        "com.hatchwithme.removeads"
    ]
    
    private init() {
        Task {
            await loadProducts()
        }
        // Listen for transaction updates
        listenForTransactions()
    }
    
    private func listenForTransactions() {
        Task.detached {
            for await result in StoreKit.Transaction.updates {
                await self.handleTransactionResult(result)
            }
        }
    }
    
    private func handleTransactionResult(_ result: VerificationResult<StoreKit.Transaction>) async {
        guard case .verified(let transaction) = result else {
            return
        }
        
        // Handle the transaction based on product ID
        switch transaction.productID {
        case "com.hatchwithme.aiassistant.subscription":
            await updateSubscriptionStatus()
        case "com.hatchwithme.removeads":
            await handleRemoveAdsPurchase()
        default:
            break
        }
        
        // Finish the transaction
        await transaction.finish()
    }
    
    func loadProducts() async {
        isLoading = true
        do {
            products = try await Product.products(for: productIDs)
            await updateSubscriptionStatus()
            await checkRemoveAdsStatus()
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    func purchase(_ product: Product) async throws {
        isLoading = true
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    switch transaction.productID {
                    case "com.hatchwithme.aiassistant.subscription":
                        await updateSubscriptionStatus()
                    case "com.hatchwithme.removeads":
                        await handleRemoveAdsPurchase()
                    default:
                        break
                    }
                    await transaction.finish()
                case .unverified:
                    throw StoreError.failedVerification
                }
            case .userCancelled:
                throw StoreError.userCancelled
            case .pending:
                throw StoreError.pending
            @unknown default:
                throw StoreError.unknown
            }
        } catch {
            self.error = error
            throw error
        }
        isLoading = false
    }
    
    func restorePurchases() async throws {
        isLoading = true
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
            await checkRemoveAdsStatus()
        } catch {
            self.error = error
            throw error
        }
        isLoading = false
    }
    
    private func updateSubscriptionStatus() async {
        for await result in StoreKit.Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.productID == "com.hatchwithme.aiassistant.subscription" {
                if transaction.revocationDate == nil {
                    subscriptionStatus = .active
                } else {
                    subscriptionStatus = .expired
                }
                return
            }
        }
        subscriptionStatus = .inactive
    }
    
    private func handleRemoveAdsPurchase() async {
        UserDefaults.standard.set(true, forKey: "hasRemovedAds")
        AdManager.shared.removeAds()
    }
    
    private func checkRemoveAdsStatus() async {
        if UserDefaults.standard.bool(forKey: "hasRemovedAds") {
            AdManager.shared.removeAds()
        }
    }
    
    var hasAIAssistant: Bool {
        subscriptionStatus == .active
    }
    
    var hasRemovedAds: Bool {
        UserDefaults.standard.bool(forKey: "hasRemovedAds")
    }
}

enum StoreError: Error {
    case failedVerification
    case userCancelled
    case pending
    case unknown
}

enum SubscriptionStatus {
    case unknown
    case active
    case inactive
    case expired
} 