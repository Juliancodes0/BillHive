//
//  EnterPayDateView.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import SwiftUI

struct TodayIsPaydayView: View {
    @StateObject var vm: EnterPayDateViewModel = EnterPayDateViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color.clearLightGray.edgesIgnoringSafeArea(.all)
            VStack(spacing: 40) {
                Text("😃 Today is payday! 💵")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                Text("Enter your next paydate")
                    .foregroundColor(.black)
                    .bold()
                DatePicker("", selection: $vm.nextPayDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .background() {
                        Color.white
                    }
                    .shadow(radius: 5)
                
                Button {
                    vm.save()
                    self.dismiss()
                } label: {
                    Text("SAVE")
                        .padding(10)
                        .bold()
                        .foregroundColor(.white)
                        .background() {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.blue.opacity(0.9))
                            
                    }
                }
            }.padding()
        }.preferredColorScheme(.light)
    }
}

struct EnterPayDateView_Previews: PreviewProvider {
    static var previews: some View {
        TodayIsPaydayView()
    }
}
