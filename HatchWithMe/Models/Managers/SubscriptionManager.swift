import StoreKit
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published var isSubscribed = false
    @Published var subscriptionPrice: String = "$2.99"
    @Published var isLoading = false
    
    private let subscriptionProductID = "com.hatchwithme.aiassistant.subscription"
    private var product: Product?
    
    private init() {
        checkSubscriptionStatus()
        Task {
            await loadProducts()
        }
    }
    
    func checkSubscriptionStatus() {
        isSubscribed = UserDefaults.standard.bool(forKey: "hasAISubscription")
    }
    
    func loadProducts() async {
        isLoading = true
        do {
            let products = try await Product.products(for: [subscriptionProductID])
            if let product = products.first {
                self.subscriptionPrice = product.displayPrice
                self.product = product
            }
        } catch {
            print("Failed to load products: \(error)")
        }
        isLoading = false
    }
    
    func purchaseSubscription() async {
        guard let product = product else {
            await loadProducts()
            if let product = self.product {
                do {
                    let result = try await product.purchase()
                    switch result {
                    case .success(let verification):
                        switch verification {
                        case .verified(let transaction):
                            await transaction.finish()
                            await updateSubscriptionStatus()
                        case .unverified:
                            print("Purchase verification failed")
                        }
                    case .userCancelled:
                        print("User cancelled purchase")
                    case .pending:
                        print("Purchase pending")
                    @unknown default:
                        print("Unknown purchase result")
                    }
                } catch {
                    print("Purchase failed: \(error)")
                }
            }
            return
        }
        
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    await updateSubscriptionStatus()
                case .unverified:
                    print("Purchase verification failed")
                }
            case .userCancelled:
                print("User cancelled purchase")
            case .pending:
                print("Purchase pending")
            @unknown default:
                print("Unknown purchase result")
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }
    
    private func updateSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.productID == subscriptionProductID {
                if transaction.revocationDate == nil {
                    isSubscribed = true
                    UserDefaults.standard.set(true, forKey: "hasAISubscription")
                } else {
                    isSubscribed = false
                    UserDefaults.standard.set(false, forKey: "hasAISubscription")
                }
                return
            }
        }
        isSubscribed = false
        UserDefaults.standard.set(false, forKey: "hasAISubscription")
    }
}

extension Product {
    var displayPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSDecimalNumber(decimal: price)) ?? "\(price)"
    }
} 
