//
//  BillModel.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation
import CoreData

struct BillModel {
    let bill: Bill
    var id: NSManagedObjectID {
        return bill.objectID
    }
    var isRecurringMonthly: Double {
        return bill.isRecurringMonthly //0 = false, 1 = true
    }
    
    var isRecurringYearly: Double {
        return bill.isRecurringYearly //0 = false, 1 = true (0 is default)
    }
    
    var isQuarterly: Double {
        return bill.isQuarterly //0 = false, 1 = true (0 is default)
    }
    
    var isPayDatePlaceHolder: Double {
        return bill.isPayDatePlaceHolder //0 = false, 1 = true (0 is default)
    }
    
    var amount: Double {
        return bill.amount
    }
    var title: String {
        return bill.title ?? ""
    }
    var dueDate: Date {
        return bill.dueDate ?? Date()
    }
    
    var notificationIdentifier: String {
        return bill.notificationIdentifier ?? ""
    }
    var details: String? {
        return bill.details ?? nil
    }
}
