//
//  CheckInViewModel.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation

class CheckInViewModel: ObservableObject {
    @Published var bills: [BillModel] = [BillModel]()
    @Published var paidBills: [PaidBillModel] = [PaidBillModel]()
    @Published var showTotalThisMonthInfo: Bool = false
    @Published var showBillListTotalInfo: Bool = false
    @Published var showBillHistory: Bool = false
    @Published var showClearHistoryButton: Bool = true
    @Published var billHistoryIsInDeletion: Bool = false
    let user = UserManager.shared
    
    
    func deletePaidBillsOlderThan30Days() {
        guard getAllPaidBillsCount() > 0 else {
            print("No paid bills found")
            return
        } // Make sure that have some PaidBills, else return

        guard let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) else {
            print("Error calculating 30 days ago")
            return
        } //Create a constant for 30 days ago

        for bill in paidBills {
            let billDateWithoutTime = Calendar.current.startOfDay(for: bill.created_paid_date) //Gets paid date for bill without considering time
            let thirtyDaysAgoWithoutTime = Calendar.current.startOfDay(for: thirtyDaysAgo) //Gets 30 days ago without consideration for time
            if billDateWithoutTime < thirtyDaysAgoWithoutTime {
                deletePaidBill(bill)
            } //delete bills if date is older than 30 days
        }
        getAllPaidBills()
    }


    func getAllPaidBillsCount () -> Int {
        var count: Int = 0
        for _ in self.paidBills {
            count += 1
        }
        return count
    }
    
    func deletePaidBill(_ bill: PaidBillModel) {
        let bill = DataPersistence.shared.getPaidBillById(bill.id)
        if let bill {
            DataPersistence.shared.deletePaidBill(bill)
        }
    }
        
    func getAllBills () {
        let bills = DataPersistence.shared.getAllBills()
            self.bills = bills.map(BillModel.init)
    }
    
    
     func getAllPaidBills () {
        let paidBills = DataPersistence.shared.getAllPaidBills()
            self.paidBills = paidBills.map(PaidBillModel.init)
    }

    
    func getAmountDueBeforeNextPayDate() -> Double {
        let nextPayDate = user.nextPayDate
        let totalAmountDue = bills.reduce(0.0) { result, bill in
            if bill.dueDate < nextPayDate {
                return result + bill.amount
            } else {
                return result
            }
        }
        return totalAmountDue
    }
    
    func getTotalBillsInList() -> Double {
        self.getAllBills()
        let total = bills.reduce(0.0) { result, bill in
            return result + bill.amount
        }
        return total
    }

    
    func getTotalThisMonth() -> Double {
        self.getAllBills()
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let total = bills.filter { bill in
            let dueMonth = Calendar.current.component(.month, from: bill.dueDate)
            let dueYear = Calendar.current.component(.year, from: bill.dueDate)
            
            print("Current Month: \(currentMonth), Current Year: \(currentYear)")
            print("Due Month: \(dueMonth), Due Year: \(dueYear)")
            
            return dueMonth == currentMonth && dueYear == currentYear
        }.reduce(0.0) { result, bill in
            return result + bill.amount
        }
        
        print("Total: \(total)")
        return total
    }

    func getPaycheckDate () -> Date {
        user.retrieveNextPayDate()
        return user.nextPayDate
    }
    
    func clearPaidBillsHistory () {
        let manager = DataPersistence.shared
        manager.deleteAllPaidBills()
        self.paidBills = manager.getAllPaidBills().map(PaidBillModel.init)
    }
}
