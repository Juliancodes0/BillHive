//
//  CheckInView.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import SwiftUI

struct CheckInView: View {
    @StateObject var vm = CheckInViewModel()
    @Environment(\.dismiss) var dismiss
    @State var totalThisMonthAmount: Double = 0
    @State var billsTotal: Double = 0
    
    var body: some View {
        ZStack {
            Color.clearLightGray.edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "dollarsign.square.fill")
                    .resizable()
                    .background() {Color.green.opacity(0.7)}.clipShape(Circle())
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                    .padding()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 50) {
                        
                        amountDue
                        nextPayDateView
                        totalThisMonth
                        totalBillsInList
                        if !vm.showBillHistory && vm.getAllPaidBillsCount() > 0 {
                            goToBillHistory.padding()
                        }
                        
                        if vm.showBillHistory {
                            Divider()
                                ForEach(vm.paidBills.sorted(by: {$0.dueDate < $1.dueDate}), id: \.id) { paidBill in
                                    PaidBillTable(paidBill: paidBill, vm: vm)
                                        .padding()
                                        .foregroundStyle(.white)
                                        .background() {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundColor(.black)
                                        }
                                }
                                
                                
                                if vm.showClearHistoryButton == true {
                                    Button(action: {
                                        vm.showClearHistoryButton = false
                                        vm.billHistoryIsInDeletion = true
                                    }, label: {
                                        Text("Clear bill history")
                                            .padding(8)
                                            .font(.headline)
                                            .bold()
                                            .foregroundStyle(.red)
                                            .background() {
                                                RoundedRectangle(cornerRadius: 5)
                                            }
                                    })
                                }
                                else if vm.showClearHistoryButton == false {
                                    Button(action: {
                                        vm.clearPaidBillsHistory()
                                        vm.showClearHistoryButton = true
                                        vm.billHistoryIsInDeletion = false
                                        vm.showBillHistory = false
                                    }, label: {
                                        Text("Confirm")
                                            .bold()
                                            .padding(8)
                                            .foregroundStyle(.red)
                                            .background() {
                                                RoundedRectangle(cornerRadius: 5)
                                            }
                                    })
                                }
                            }
                            
                        
                
                        Spacer()
                        Button(action: {
                            dismiss.callAsFunction()
                        }, label: {
                            Text("DONE")
                                .bold()
                                .padding()
                                .foregroundColor(.white)
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.black).opacity(0.3)
                        )
                    }
                    .padding()
                }
            }
            .foregroundColor(.white)
            .onTapGesture {
                withAnimation() {
                    if !vm.billHistoryIsInDeletion {
                        vm.showTotalThisMonthInfo = false
                        vm.showBillListTotalInfo = false
                        vm.showBillHistory = false
                    }
                    if vm.billHistoryIsInDeletion {
                        vm.showClearHistoryButton = true
                        vm.billHistoryIsInDeletion = false
                    }
                }
            }
            .preferredColorScheme(.light)
        }
        .onAppear() {
            totalThisMonthAmount = vm.getTotalThisMonth()
            billsTotal = vm.getTotalBillsInList()
            vm.getAllPaidBills()
            vm.deletePaidBillsOlderThan30Days()
        }
        .shadow(radius: 5)
    }
}

extension CheckInView {
    var amountDue: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Amount due before next pay date: ")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("\(vm.getAmountDueBeforeNextPayDate().with2Decimals().withCommaSeparator())")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue.opacity(0.8))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    var nextPayDateView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Next Pay Date: ")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("\(vm.getPaycheckDate().formatted(date: .abbreviated, time: .omitted))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue.opacity(0.8))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    
    var totalThisMonth: some View {
        VStack {
            HStack {
                Text("Total left in \(self.getCurrentMonthName()): \(totalThisMonthAmount.with2Decimals().withCommaSeparator())")
                    .font(.headline)
                    .foregroundColor(.white)
                
                totalThisMonthInfoButton
                
                if vm.showTotalThisMonthInfo {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("This is the total amount of bills you have left within the current month.")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        Text("Tap anywhere to dismiss.")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                }
            }
            .padding()
            .background(Color.blue.opacity(0.8))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }

    var totalThisMonthInfoButton: some View {
        Button {
            withAnimation {
                vm.showTotalThisMonthInfo.toggle()
            }
        } label: {
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
        }
    }

    var totalBillsInList: some View {
        HStack {
            Text("Total of all saved bills: \(self.billsTotal.with2Decimals().withCommaSeparator())")
                .font(.headline)
                .foregroundColor(.white)
            
            totalBillsInfo
            
            if vm.showBillListTotalInfo {
                VStack(alignment: .leading, spacing: 4) {
                    Text("This is a calculation of all your saved bills, even those due in another month/year.")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Text("Tap anywhere to dismiss.")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.8))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    var totalBillsInfo: some View {
        Button {
            withAnimation {
                vm.showBillListTotalInfo.toggle()
            }
        } label: {
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
        }
    }
    
    var goToBillHistory: some View {
        Button(action: {
            withAnimation {
                vm.showBillHistory = true
            }
        }, label: {
            Text("View bills paid in the last 30 days")
                .padding()
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
                .background() {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.blue)
                }
        })
    }
    
    func getCurrentMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let currentMonth = Date()
        return dateFormatter.string(from: currentMonth)
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
    }
}
