//
//  BillsListViewModel.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation
import CoreData
import UserNotifications

class BillsListViewModel : ObservableObject {
    @Published var bills: [BillModel] = [BillModel]()
    @Published var goToMenuView: Bool = false
    @Published var goToEditBill: Bool = false
    let user = UserManager.shared
    
    func getAllBills () {
        let bills = DataPersistence.shared.getAllBills()
        DispatchQueue.main.async {
            self.bills = bills.map(BillModel.init)
        }
    }
    
    func getBillCount () -> Int {
        var count = 0
        for _ in self.bills {
            count += 1
        }
        return count
    }
    
    func deleteBill (_ bill: BillModel) {
        removeNotification(bill)
        let title = bill.title
        let amount = bill.amount
        let dueDate = bill.dueDate
        let details = bill.details
        let bill = DataPersistence.shared.getBillById(bill.id)
        if let bill {
            createPaidBill(title: title, amount: amount, details: details, dueDate: dueDate, created_paid_date: Date())
            DataPersistence.shared.deleteBill(bill)
        }
    }
    
    func removeNotification(_ bill: BillModel) {
        let notificationIdentifier = bill.notificationIdentifier
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationIdentifier])
    }
    
    func resetBillWithMonthlyOption(_ bill: BillModel) {
        let originalDueDate = bill.dueDate
        let newDueDate = Calendar.current.date(byAdding: .month, value: 1, to: originalDueDate)
        let title = bill.title
        let amount = bill.amount
        let isRecurringMonthly = bill.isRecurringMonthly
        let isQuarterly = bill.isQuarterly
        let isRecurringYearly = bill.isRecurringYearly
        let uniqueId = bill.notificationIdentifier
        let details = bill.details
        let manager = DataPersistence.shared
        guard let oldBill = manager.getBillById(bill.id) else {return}
        manager.deleteBill(oldBill)
        createPaidBill(title: title, amount: amount, details: details, dueDate: originalDueDate, created_paid_date: Date())
        let newBill = Bill(context: manager.persistentContainer.viewContext)
        newBill.dueDate = newDueDate
        newBill.amount = amount
        newBill.isRecurringMonthly = isRecurringMonthly
        newBill.isQuarterly = isQuarterly
        newBill.isRecurringYearly = isRecurringYearly
        newBill.title = title
        newBill.notificationIdentifier = uniqueId
        manager.save()
        NotificationManager.shared.sendPushNotifications()
    }
    
    
    func resetBillWithQuaterlyOption (_ bill: BillModel) {
        let originalDueDate = bill.dueDate
        let newDueDate = Calendar.current.date(byAdding: .month, value: 3, to: originalDueDate)
        let title = bill.title
        let amount = bill.amount
        let isRecurringMonthly = bill.isRecurringMonthly
        let isRecurringYearly = bill.isRecurringYearly
        let isQuarterly = bill.isQuarterly
        let uniqueId = bill.notificationIdentifier
        let details = bill.details
        let manager = DataPersistence.shared
        guard let oldBill = manager.getBillById(bill.id) else { return }
        manager.deleteBill(oldBill)
        createPaidBill(title: title, amount: amount, details: details, dueDate: originalDueDate, created_paid_date: Date())
            let newBill = Bill(context: manager.persistentContainer.viewContext)
            newBill.dueDate = newDueDate
            newBill.amount = amount
            newBill.isRecurringMonthly = isRecurringMonthly
            newBill.isRecurringYearly = isRecurringYearly
            newBill.isQuarterly = isQuarterly
            newBill.title = title
            newBill.notificationIdentifier = uniqueId
            newBill.details = details
            manager.save()
            NotificationManager.shared.sendPushNotifications()
    }
    
    func resetBillWithAnnualOption(_ bill: BillModel) {
        let originalDueDate = bill.dueDate
        let newDueDate = Calendar.current.date(byAdding: .year, value: 1, to: originalDueDate)
        let title = bill.title
        let amount = bill.amount
        let isRecurringMonthly = bill.isRecurringMonthly
        let isQuarterly = bill.isQuarterly
        let isRecurringYearly = bill.isRecurringYearly
        let uniqueId = bill.notificationIdentifier
        let details = bill.details
        let manager = DataPersistence.shared
        guard let oldBill = manager.getBillById(bill.id) else {return}
        manager.deleteBill(oldBill)
        createPaidBill(title: title, amount: amount, details: details, dueDate: originalDueDate, created_paid_date: Date())
        let newBill = Bill(context: manager.persistentContainer.viewContext)
        newBill.dueDate = newDueDate
        newBill.amount = amount
        newBill.isRecurringMonthly = isRecurringMonthly
        newBill.isQuarterly = isQuarterly
        newBill.isRecurringYearly = isRecurringYearly
        newBill.title = title
        newBill.notificationIdentifier = uniqueId
        newBill.details = details
        manager.save()
        NotificationManager.shared.sendPushNotifications()
    }
    
    
    func getBillTotal () -> Double {
        var total: Double = 0
        for i in bills {
            total += i.amount
        }
        return total
    }
    
    private func createPaidBill (title: String, amount: Double, details: String?, dueDate: Date, created_paid_date: Date) {
        let manager = DataPersistence.shared
        let paidBill = PaidBill(context: manager.persistentContainer.viewContext)
        paidBill.title = title
        paidBill.amount = amount
        paidBill.details = details
        paidBill.dueDate = dueDate
        paidBill.created_paid_date = created_paid_date
        manager.save()
    }
}
