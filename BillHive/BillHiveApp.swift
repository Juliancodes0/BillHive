//
//  BillHiveApp.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import SwiftUI

@main
struct BillHiveApp: App {
    let user = UserManager()
    var body: some Scene {
        WindowGroup {
            FirstAppearance()
        }
    }
}


class VersionConditions {
    ///Use if is first launch on version 2.5 - not yet implemented
    func createPayDatePlaceholder () {
        let user = UserManager.shared
        user.saveNextPayDate()
        user.userLoadedApp = true
        user.saveUserLoadedApp()
        let manager = DataPersistence.shared
        manager.deletePayDatePlaceHolder()
        let payDatePlaceHolder = Bill(context: manager.persistentContainer.viewContext)
        payDatePlaceHolder.title = ""
        payDatePlaceHolder.isPayDatePlaceHolder = 1
        payDatePlaceHolder.dueDate = user.retrieveNextPayDate()
        payDatePlaceHolder.details = ""
        payDatePlaceHolder.amount = 0
        payDatePlaceHolder.isRecurringMonthly = 0
        payDatePlaceHolder.isRecurringYearly = 0
        payDatePlaceHolder.isQuarterly = 0
        payDatePlaceHolder.notificationIdentifier = ""
        manager.save()
    }
}
