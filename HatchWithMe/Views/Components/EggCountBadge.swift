import SwiftUI

struct EggCountBadge: View {
    let count: Int16
    let total: Int16
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(count)")
                .font(.subheadline)
                .bold()
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
} 