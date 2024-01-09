//
//  Date+Extensions.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.string(from: self)
    }
}
