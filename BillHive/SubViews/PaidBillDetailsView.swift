//
//  PaidBillDetailsView.swift
//  BillHive
//
//  Created by Julian Burton on 12/25/23.
//

import SwiftUI

struct PaidBillDetailsView: View {
    @Environment(\.dismiss) var dismiss
    let bill: PaidBillModel
    
    var body: some View {
        ZStack {
            Color.clearLightGray
                .edgesIgnoringSafeArea(.all).opacity(1)
            
            VStack(spacing: 16) {
                HStack {
                    Text(bill.title)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.white, Color.green)
                        .shadow(radius: 2)
                }.padding()

                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.white)
                    Text(bill.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .foregroundStyle(.black)
                }
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.white)
                    Text(bill.amount.with2Decimals().withCommaSeparator())
                        .foregroundColor(.black)
                }
                
                Text("This bill was paid on: \(bill.created_paid_date.formatted(date: .abbreviated, time: .omitted))")
                    .padding()
                    .foregroundStyle(.black)
                    .bold()

                
                if let details = bill.details {
                    Rectangle()
                        .foregroundColor(.clearLightGray)
                        .cornerRadius(8)
                        .overlay(
                            ScrollView(showsIndicators: false) {
                                Text(details)
                                    .foregroundColor(.white)
                                    .padding()
                            }).shadow(radius: 5)
                }
            }
        }.preferredColorScheme(.light)
    }
}

struct PaidBillDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let paidBill = PaidBill(context: DataPersistence.shared.viewContext)
        
        let paidBillModel = PaidBillModel(paidBill: paidBill)
        PaidBillDetailsView(bill: paidBillModel)
    }
}
