//
//  DataPersistence.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation
import CoreData

class DataPersistence {
    let persistentContainer: NSPersistentContainer
    
    static let shared = DataPersistence()
    
    init () {
        persistentContainer = NSPersistentContainer(name: "CoinAppModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getBillById(_ id: NSManagedObjectID) -> Bill? {
        do {
            return try viewContext.existingObject(with: id) as? Bill
        } catch {
            return nil
        }
    }
    
    func getPaidBillById(_ id: NSManagedObjectID) -> PaidBill? {
        do {
            return try viewContext.existingObject(with: id) as? PaidBill
        } catch {
            return nil
        }
    }
    
    func deleteBill(_ bill: Bill) {
        persistentContainer.viewContext.delete(bill)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func deletePaidBill(_ bill: PaidBill) {
        persistentContainer.viewContext.delete(bill)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func getAllBills () -> [Bill] {
        let fetchRequest: NSFetchRequest<Bill> = Bill.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func deleteAllBills () {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bill")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(batchDeleteRequest)
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func deleteAllPaidBills () {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaidBill")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(batchDeleteRequest)
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func save () {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func getAllPaidBills () -> [PaidBill] {
        let fetchRequest: NSFetchRequest<PaidBill> = PaidBill.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
}


extension DataPersistence {
    
    func deletePayDatePlaceHolder () {
        for bill in self.getAllBills() {
            if bill.isPayDatePlaceHolder == 1 {
                self.persistentContainer.viewContext.delete(bill)
            }
        }
    }
}
