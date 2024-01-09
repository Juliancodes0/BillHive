//
//  FirstAppearance.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import SwiftUI

struct FirstAppearance: View {
    let user: UserManager = UserManager.shared
    @StateObject var vm: FirstAppearanceViewModel = FirstAppearanceViewModel()
    var body: some View {
        ZStack {
            Color.clearLightGray.edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "dollarsign.square.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
            }
        }
        .onAppear() {
            NotificationManager.shared.getAllBills()
            NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            user.retrieveUserLoadedAppStatus()
            user.retrieveNextPayDate()
            
            if user.userLoadedApp == true && vm.segueUserToUpdatePayScreen() == false {
                vm.goToMainView = true
            } else if user.userLoadedApp == false {
                vm.goToInfoView = true
            } else if vm.segueUserToUpdatePayScreen() == true {
                vm.goToUpdatePayDateView = true
            }
            NotificationManager.shared.requestAuth()
        }
        
        
        
        .fullScreenCover(isPresented: $vm.goToInfoView, onDismiss: {
            vm.goToMainView = true
        }, content: {
            EnterNextPayDateView()
        })
        .fullScreenCover(isPresented: $vm.goToMainView, content: {
            BillsListView()
        })
        .fullScreenCover(isPresented: $vm.goToUpdatePayDateView, onDismiss: {
            vm.goToMainView = true
        }, content: {
            TodayIsPaydayView()
        })
        .preferredColorScheme(.light)
    }
}

struct FirstAppearance_Previews: PreviewProvider {
    static var previews: some View {
        FirstAppearance()
    }
}
