//
//  PaidBillModel.swift
//  BillHive
//
//  Created by Julian Burton on 10/27/23.
//

import Foundation
import CoreData

struct PaidBillModel {
    let paidBill: PaidBill
    var id: NSManagedObjectID {
        return paidBill.objectID
    }
    var title: String {
        return paidBill.title ?? ""
    }
    var details: String? {
        return paidBill.details ?? nil
    }
    var amount: Double {
        return paidBill.amount
    }
    var dueDate: Date {
        return paidBill.dueDate ?? Date()
    }
    var created_paid_date: Date {
        return paidBill.created_paid_date ?? Date()
    }
}
