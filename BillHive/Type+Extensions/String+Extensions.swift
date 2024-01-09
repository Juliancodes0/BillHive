//
//  String+Extensions.swift
//  BillHive
//
//  Created by Julian Burton on 7/11/23.
//

import Foundation

extension String {
    func withCommaSeparator() -> String {
        let numberFormatter = NumberFormatter.currencyFormatter
        guard let amount = Double(self),
              let formattedString = numberFormatter.string(from: NSNumber(value: amount)) else {
            return ""
        }
        return formattedString
    }
}
