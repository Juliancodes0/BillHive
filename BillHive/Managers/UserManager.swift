//
//  UserManager.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    var userLoadedApp: Bool = false
    var nextPayDate: Date = Date()
    
    func saveUserLoadedApp() {
        if let encodedData = try? JSONEncoder().encode(self.userLoadedApp) {
            UserDefaults.standard.set(encodedData, forKey: "UserLoadedApp")
        }
    }
    
    func retrieveUserLoadedAppStatus() {
        guard let userLoadedApp = UserDefaults.standard.data(forKey: "UserLoadedApp") else {return}
        guard let decodedBool = try? JSONDecoder().decode(Bool.self, from: userLoadedApp) else {return}
        self.userLoadedApp = decodedBool
    }
    
    func saveNextPayDate () {
        if let encoded = try? JSONEncoder().encode(self.nextPayDate) {
            UserDefaults.standard.set(encoded, forKey: "NextPayDate")
        }
    }
    
    @discardableResult
    func retrieveNextPayDate () -> Date {
        guard let date = UserDefaults.standard.data(forKey: "NextPayDate") else {return Date()}
        guard let decodedDate = try? JSONDecoder().decode(Date.self, from: date) else {return Date()}
        self.nextPayDate = decodedDate
        return decodedDate
    }
}


enum SeguedFrom {
    case billListView
    case firstAppearance
}
