//
//  InfoView.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import SwiftUI

struct EnterNextPayDateView: View {
    @StateObject var vm: EnterNextPayDateViewModel = EnterNextPayDateViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color.clearLightGray.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Image(systemName: "dollarsign.square.fill")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
                    .background() {Color.green.opacity(0.7)}
                    .clipShape(Circle())
                Text("Bill Hive")
                    .bold()
                    .foregroundColor(.black)
                HStack(spacing: 15) {
                }.padding()
                HStack {
                    VStack {
                        Text("Enter your next paycheck date")
                            .foregroundColor(.black)
                            .bold()
                        Spacer()
                        DatePicker("Pay Date:", selection: $vm.nextPayDate, displayedComponents: .date)
                            .padding(.leading)
                            .datePickerStyle(.graphical)
                            .background() {
                                Rectangle()
                                    .foregroundColor(.white.opacity(0.7))
                            }

                    }
                }
                Spacer()
                Button {
                    vm.save()
                    self.dismiss()
                } label: {
                    Text("SAVE")
                        .padding(10)
                        .foregroundColor(.white)
                        .bold()
                        .background() {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor( .blue)
                        }
                }.padding(10)
                Spacer()
            }
        }.preferredColorScheme(.light)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        EnterNextPayDateView()
    }
}
