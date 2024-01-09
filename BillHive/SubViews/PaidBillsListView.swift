//
//  PaidBillsListView.swift
//  BillHive
//
//  Created by Julian Burton on 10/27/23.
//

import SwiftUI

struct PaidBillTable: View {
    let paidBill: PaidBillModel
    @StateObject var vm: CheckInViewModel
    @State var goToBillsDetails: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("\(paidBill.title)")
                    .foregroundColor(.white)
                    .padding(.trailing, 10)
                Spacer(minLength: 0)
                
                HStack {
                    Text(paidBill.amount.with2Decimals().withCommaSeparator())
                        .foregroundColor(.green)
                        .frame(width: 100, alignment: .leading)
                    
                    Text(paidBill.dueDate.formattedDate())
                        .foregroundColor(.white)
                        .frame(width: 80, alignment: .leading)
                }
                
                Button {
                    self.goToBillsDetails = true
                } label: {
                    Image(systemName: "note.text")          
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(.plain)
                
            }
        }
        .popover(isPresented: $goToBillsDetails, content: {
            PaidBillDetailsView(bill: paidBill)
        })
    }
}


struct PaidBillsListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
        }
    }
}
