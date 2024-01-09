//
//  InfoViewViewModel.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation

class EnterNextPayDateViewModel: ObservableObject {
    @Published var nextPayDate: Date = Date()
    @Published var goToBillsListView: Bool = false
    
    func save () {
        let user = UserManager.shared
        user.nextPayDate = nextPayDate
        user.saveNextPayDate()
        user.userLoadedApp = true
        user.saveUserLoadedApp()
        let manager = DataPersistence.shared
        manager.deletePayDatePlaceHolder()
        let payDatePlaceHolder = Bill(context: manager.persistentContainer.viewContext)
        payDatePlaceHolder.title = ""
        payDatePlaceHolder.isPayDatePlaceHolder = 1
        payDatePlaceHolder.dueDate = nextPayDate
        payDatePlaceHolder.details = ""
        payDatePlaceHolder.amount = 0
        payDatePlaceHolder.isRecurringMonthly = 0
        payDatePlaceHolder.isRecurringYearly = 0
        payDatePlaceHolder.isQuarterly = 0
        payDatePlaceHolder.notificationIdentifier = ""
        manager.save()
        self.goToBillsListView = true
    }
}
