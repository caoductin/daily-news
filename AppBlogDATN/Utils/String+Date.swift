//
//  String+Date.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 8/6/25.
//

import Foundation
extension String {
    func timeAgoFromISO8601() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = formatter.date(from: self) else {
            return ""
        }
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        if let year = components.year, year > 0 {
            return "\(year) năm trước"
        } else if let month = components.month, month > 0 {
            return "\(month) tháng trước"
        } else if let day = components.day, day > 0 {
            return "\(day) ngày trước"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) giờ trước"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) phút trước"
        } else {
            return "Vừa xong"
        }
    }
}
