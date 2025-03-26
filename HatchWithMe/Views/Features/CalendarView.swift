//
//  CalendarView.swift
//  HatchWithMe
//
//  Created by Austin Beck on 9/19/24.
//

import SwiftUI

struct CalendarView: View {
    let hatch: Hatch
    
    var body: some View {
        let totalDays = Int(hatch.birdType.incubationPeriod)
        let daysArray = Array(0..<totalDays + 1)
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(daysArray, id: \.self) { day in
                let currentDay = Calendar.current.date(byAdding: .day, value: day, to: hatch.startDate)!
                
                DayView(
                    date: currentDay,
                    isToday: isToday(date: currentDay),
                    isLockdownDay: isLockdownDay(date: currentDay),
                    isHatchDay: isHatchDay(date: currentDay)
                )
            }
        }
    }
    
    // MARK: - Helper Methods to Check Dates
    
    private func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private func isLockdownDay(date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: hatch.lockdownDate)
    }
    
    private func isHatchDay(date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: hatch.hatchDate)
    }
}
