//
//  NotificationManager.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    var bills: [BillModel] = [BillModel]()
    
    func getAllBills () {
        let bills = DataPersistence.shared.getAllBills()
        self.bills = bills.map(BillModel.init)
    }
    
    func requestAuth () {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            
            if let error {
                fatalError("Error: \(error.localizedDescription)")
            } else {
                print ("Success")
            }
        }
    }
    
    func sendPushNotifications() {
        self.getAllBills()
        var uniqueDates = Set<Date>()

        for bill in bills {
            let calendar = Calendar.current
            let dueDateComponents = calendar.dateComponents([.year, .month, .day], from: bill.dueDate)

            var triggerDateComponents = DateComponents()
            triggerDateComponents.year = dueDateComponents.year
            triggerDateComponents.month = dueDateComponents.month
            triggerDateComponents.day = dueDateComponents.day
            triggerDateComponents.hour = 10
            triggerDateComponents.minute = 15

            guard let triggerDate = calendar.date(from: triggerDateComponents) else {
                continue
            }

            // Check if the trigger date is already scheduled
            if uniqueDates.contains(triggerDate) {
                continue
            }

            uniqueDates.insert(triggerDate)

            let content = UNMutableNotificationContent()
            content.title = "Check bills"
            content.body = "Check your list of bills and make sure you're up to date!"
            content.badge = 1

            let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate), repeats: false)
            let request = UNNotificationRequest(identifier: bill.notificationIdentifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    // Handle any errors in notification scheduling
                    print("Notification error: \(error.localizedDescription)")
                } else {
                    // Notification scheduled successfully
                    print("Notification scheduled for bill \(bill.id)")
                }
            }
        }
    }
}
