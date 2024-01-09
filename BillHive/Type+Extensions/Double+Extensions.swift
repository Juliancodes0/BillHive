//
//  Double+Extensions.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation

extension Double {
    func with2Decimals() -> String {
        return String(format: "%.2f", self)
    }
}

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
