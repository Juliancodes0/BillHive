//
//  FirstAppearanceViewModel.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation

class FirstAppearanceViewModel: ObservableObject {
    let user = UserManager.shared
    @Published var goToUpdatePayDateView: Bool = false
    @Published var goToInfoView: Bool = false
    @Published var goToMainView: Bool = false
    
    func segueUserToUpdatePayScreen() -> Bool {
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let nextPayDateComponents = calendar.dateComponents([.year, .month, .day], from: user.nextPayDate)

        if let currentDate = calendar.date(from: currentDateComponents),
           let nextPayDate = calendar.date(from: nextPayDateComponents),
           calendar.isDate(currentDate, inSameDayAs: nextPayDate) {
            goToUpdatePayDateView = true
            print ("returned true")
            return true
        } else {
            print ("returned false")
            return false
        }
    }
}
