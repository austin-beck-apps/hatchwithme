//
//  DayView.swift
//  HatchWithMe
//
//  Created by Austin Beck on 9/19/24.
//

import SwiftUI

struct DayView: View {
    let date: Date
    let isToday: Bool
    let isLockdownDay: Bool
    let isHatchDay: Bool
    
    var body: some View {
        VStack {
            Text(dayFormatter.string(from: date))
                .padding(8)
                .background(backgroundColor)
                .clipShape(Circle())
                .foregroundColor(.white)
        }
    }
    
    // Background color based on the important dates
    private var backgroundColor: Color {
        if isHatchDay {
            return .green
        } else if isLockdownDay {
            return .orange
        } else if isToday {
            return .blue
        } else {
            return .gray
        }
    }
}

private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
}()
