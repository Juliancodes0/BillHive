//
//  EditBillViewModel.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation
import UserNotifications

class EditBillViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var dueDate: Date = Date()
    @Published var isRecurring: Double = 1
    @Published var title: String = ""
    @Published var details: String = ""

    
    @Published var isYesRecurringSelected: Bool = false
    @Published var isRecurringNotSelected: Bool = false
    
    @Published var isAnnual: Bool = false
    @Published var isMonthly: Bool = false
    @Published var isQuarterly: Bool = false

    let user = UserManager.shared
    
//    func editBill (bill: Bill) {
//        guard self.amount.count > 0 && self.title.count > 0 else {return}
//        let manager = DataPersistence.shared
//        let uniqueId: String = bill.notificationIdentifier ?? ""
//        self.removeNotification(bill)
//        manager.deleteBill(bill)
//        let editedBill = Bill(context: manager.persistentContainer.viewContext)
//        editedBill.amount = Double(self.amount) ?? 0
//        editedBill.dueDate = self.dueDate
//        editedBill.isRecurringMonthly = self.isYesSelected == true && isNoSelected == false ? 1 : 0
//        editedBill.title = self.title
//        editedBill.notificationIdentifier = uniqueId
//        if self.details != "" {editedBill.details = self.details} else if self.details == "" {editedBill.details = nil}
//        manager.save()
//        NotificationManager.shared.sendPushNotifications()
//    }
    
    func editSavedBill (bill: Bill) { //second function to try, retest notifications
        guard self.amount.count > 0 && self.title.count > 0 else {return}
        guard self.title != "" else {return}
        let manager = DataPersistence.shared
        let uniqueId: String = bill.notificationIdentifier ?? ""
        self.removeNotification(bill)
        manager.deleteBill(bill)
        
        let editedBill = Bill(context: manager.persistentContainer.viewContext)
        editedBill.amount = Double(self.amount) ?? 0
        editedBill.dueDate = self.dueDate
        editedBill.title = self.title
        editedBill.notificationIdentifier = uniqueId
        if self.details != "" {editedBill.details = self.details}
        if self.details == "" {editedBill.details = nil}
        if self.isYesRecurringSelected {
            editedBill.isRecurringMonthly = self.isMonthly ? 1 : 0
            editedBill.isRecurringYearly = self.isAnnual ? 1 : 0
            editedBill.isQuarterly = self.isQuarterly ? 1 : 0
        } else if self.isRecurringNotSelected {bill.isRecurringYearly = 0; bill.isRecurringMonthly = 0}
        bill.isPayDatePlaceHolder = 0
        manager.save()
        NotificationManager.shared.sendPushNotifications()
    }
    
    func removeNotification(_ bill: Bill) {
        if let notificationIdentifier = bill.notificationIdentifier {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationIdentifier])
        }
    }

    func allOptionsRequiredSelected () -> Bool {
        if self.isYesRecurringSelected && self.isAnnual || self.isMonthly || self.isQuarterly {
            return true
        }
        if self.isRecurringNotSelected {
            return true
        }
        return false
    }
    
    ///Use this function for if "Yes" option is deselected.
    func setAllRecurringOptionsToFalse () {
        self.isMonthly = false
        self.isAnnual = false
        self.isQuarterly = false
    }

    
    func getOldBillInfo(_ bill: BillModel) {
        self.title = bill.title
        self.dueDate = bill.dueDate
        self.amount = String(bill.amount)
        self.details = bill.details ?? ""
    }
}
