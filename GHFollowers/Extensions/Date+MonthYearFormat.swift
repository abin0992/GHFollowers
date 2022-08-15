//
//  Date+MonthYearFormat.swift
//  GHFollowers
//
//  Created by Abin Baby on 01/01/21.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
