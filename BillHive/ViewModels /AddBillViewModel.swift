//
//  AddBillViewModel.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation

class AddBillViewModel : ObservableObject {
    @Published var amount: String = ""
    @Published var dueDate: Date = Date()
    @Published var title: String = ""
    @Published var details: String = ""
    
    @Published var isYesReccuringSelected: Bool = false
    @Published var isRecurringNotSelected: Bool = false
    
    @Published var isAnnual: Bool = false
    @Published var isMonthly: Bool = false
    @Published var isQuarterly: Bool = false
        
    func saveBill () { //second function to try, retest notifications
        guard self.title != "" else {return}
        let manager = DataPersistence.shared
        let bill = Bill(context: manager.persistentContainer.viewContext)
        bill.amount = Double(self.amount) ?? 0
        bill.dueDate = self.dueDate
        bill.title = self.title
        if self.details != "" {bill.details = self.details}
        if self.details == "" {bill.details = nil}
        bill.notificationIdentifier = UUID().uuidString
        if self.isYesReccuringSelected {
            bill.isRecurringMonthly = self.isMonthly ? 1 : 0
            bill.isRecurringYearly = self.isAnnual ? 1 : 0
            bill.isQuarterly = self.isQuarterly ? 1 : 0
        } else if self.isRecurringNotSelected {bill.isRecurringYearly = 0; bill.isRecurringMonthly = 0}
        bill.isPayDatePlaceHolder = 0
        manager.save()
    }
    
    ///Use this function for if "Yes" option is deselected.
    func setAllRecurringOptionsToFalse () {
        self.isMonthly = false
        self.isAnnual = false
        self.isQuarterly = false
    }
    
    
    func allOptionsRequiredSelected () -> Bool {
        if self.isYesReccuringSelected && self.isAnnual || self.isMonthly || self.isQuarterly {
            return true
        }
        if self.isRecurringNotSelected {
            return true
        }
        return false
    }
}
