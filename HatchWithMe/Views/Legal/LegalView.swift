import SwiftUI

struct LegalView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Terms of Use Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Terms of Use")
                            .font(.title2)
                            .bold()
                        
                        Text("Last updated: March 25, 2024")
                            .foregroundColor(.secondary)
                        
                        Text("By using Hatch With Me, you agree to these terms:")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• You must be at least 13 years old to use this app")
                            Text("• You are responsible for maintaining the security of your account")
                            Text("• You agree not to use the app for any illegal purposes")
                            Text("• We reserve the right to modify or terminate the service at any time")
                            Text("• All content and features are provided 'as is' without warranties")
                        }
                        .padding(.leading)
                    }
                    
                    Divider()
                    
                    // Privacy Policy Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Privacy Policy")
                            .font(.title2)
                            .bold()
                        
                        Text("Last updated: March 25, 2024")
                            .foregroundColor(.secondary)
                        
                        Text("We collect and use your data as follows:")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• We store your hatch data locally on your device")
                            Text("• We use analytics to improve the app experience")
                            Text("• We do not share your personal information with third parties")
                            Text("• You can request deletion of your data at any time")
                        }
                        .padding(.leading)
                    }
                }
                .padding()
            }
            .navigationTitle("Legal")
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