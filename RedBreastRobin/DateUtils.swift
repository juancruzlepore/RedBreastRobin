//
//  DateUtils.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 22/1/21.
//

import Foundation

class DateUtils {
    
    private static var formatter = DateFormatter()
    
    public static func formatLongDateWithMinutes(date: Date) -> String {
        formatter.dateFormat = "HH:mm E, d MMM"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
    
    public static func formatJustMinutes(date: Date) -> String {
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = .current
        return formatter.string(from: date)

    }
    
    public static func parseISO8601(fromString str: String) -> Date? {
        return ISO8601DateFormatter().date(from: str)
    }
    
    public static func isToday(date: Date) -> Bool {
        let today = Date()
        return Calendar.current.compare(date, to: today, toGranularity: .day) == .orderedSame
    }
    
    public static func isTomorrow(date: Date) -> Bool {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return Calendar.current.compare(date, to: tomorrow, toGranularity: .day) == .orderedSame
    }
    
    public static func isYesterday(date: Date) -> Bool {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return Calendar.current.compare(date, to: yesterday, toGranularity: .day) == .orderedSame
    }
            
}
