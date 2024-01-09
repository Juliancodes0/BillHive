//
//  InfoViewFromList.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import Foundation
import SwiftUI

struct InfoViewFromList: View {
    @StateObject var vm: EnterPayDateFromBillListViewModel = EnterPayDateFromBillListViewModel()
    @Environment(\.dismiss) var dismiss
    var completion: ( () -> ()?)?
    var body: some View {
        ZStack {
            Color.clearLightGray.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Image(systemName: "dollarsign.square.fill")
                    .resizable()
                    .background() {Color.green.opacity(0.7)}.clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
                Text("BillHive")
                    .bold()
                    .foregroundColor(.black)
                HStack(spacing: 15) {
                }.padding()
                HStack {
                    VStack {
                        Text("Enter your next paycheck date")
                            .foregroundColor(.black)
                            .bold()
                        DatePicker("Pay Date:", selection: $vm.nextPayDate, displayedComponents: .date)
                            .frame(width: 250, height: 50)
                            .padding(.leading)
                            .padding(.trailing)
                            .datePickerStyle(.automatic)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.white)
                            }
                    }
                }
                
                Button {
                        vm.save()
                        completion?()
                        dismiss.callAsFunction()
                } label: {
                    Text("SAVE")
                        .foregroundStyle(Color.white)
                        .bold()
                        .padding(10)
                        .foregroundColor(.black.opacity(0.8))
                        .background() {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.blue.opacity(0.9))
                        }
                }
            }
        }.preferredColorScheme(.light)
    }
}

struct InfoViewFromList_Previews: PreviewProvider {
    static var previews: some View {
        InfoViewFromList()
    }
}

