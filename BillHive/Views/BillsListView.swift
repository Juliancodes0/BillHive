//
//  BillsListView.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import SwiftUI

struct BillsListView: View {
    @StateObject var vm: BillsListViewModel = BillsListViewModel()
    @State var goToAddBill: Bool = false
    @State var goToCheckInView: Bool = false
    let user = UserManager.shared
    var body: some View {
        ZStack {
            Color.clearLightGray.edgesIgnoringSafeArea(.all)
            VStack() {
                    Button {
                        goToCheckInView = true
                    } label: {
                        HStack(spacing: 3) {
                            Image(systemName: "dollarsign.square.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                                .background() {Color.green}
                                .clipShape(Circle())
                            
                            Text(" Overview")
                                .foregroundColor(.black)
                                .bold()
                        }
                    }
                    HStack {
                        Button {
                            vm.goToMenuView = true
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .frame(width: 23.5, height: 13.5)
                                .foregroundColor(.black)
                                .bold()
                        }.padding(.leading, 3)
                        Spacer()
                    }.padding(5)
                if vm.getBillCount() != 0 {
                    List {
                        ForEach(vm.bills.sorted(by: {$0.dueDate < $1.dueDate}), id: \.id) { bill in
                            HStack {
                                BillTable(bill: bill, vm: vm, actionMarkPaid: {vm.getAllBills()})
                            }
                                .foregroundColor(.white)
                                .listRowBackground(Color.customGray)
                        }
                    }.listStyle(.plain)
                } else if vm.getBillCount() == 0 {
                    List {
                        Button {
                            goToAddBill = true
                        } label: {
                            Text("Add a bill")
                                .bold()
                                .foregroundColor(.blue)
                        }.listRowBackground(Color.customGray)
                    }
                    .listStyle(.plain)
                }
                HStack {
                    Spacer()
                    Button {
                        goToAddBill = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                            .padding()
                            .background() {
                                    Circle()
                                    .frame(width: 43, height: 43)
                                    .foregroundColor(.black)
                            }
                    }.padding(.trailing)
                }
            }
        }
        .onAppear() {
            vm.getAllBills()
        }
        .sheet(isPresented: $goToAddBill, onDismiss: {
            vm.getAllBills()
            NotificationManager.shared.sendPushNotifications()
        }, content: {
            AddBillView()
        })
        .sheet(isPresented: $goToCheckInView, content: {
            CheckInView()
        })
        .sheet(isPresented: $vm.goToMenuView, content: {
            MenuView() {
                vm.getAllBills()
            }
        })
        .preferredColorScheme(.light)
    }
}


struct BillTable: View {
    let bill: BillModel
    @StateObject var vm: BillsListViewModel
    @State var goToBillDetails: Bool = false
    @State var goToEditBill: Bool = false
    
    var actionMarkPaid: (() -> Void)
    
    var body: some View {
        VStack {
            HStack {
                Text("\(bill.title)")
                    .foregroundColor(.white)
                    .padding(.trailing, 10)
                Spacer(minLength: 0)
                
                HStack {
                    Text(bill.amount.with2Decimals().withCommaSeparator())
                        .foregroundColor(.green)
                        .frame(width: 100, alignment: .leading)
                    
                    Text(bill.dueDate.formattedDate())
                        .foregroundColor(self.getTextColor(for: bill.dueDate))
                        .frame(width: 80, alignment: .leading)
                }
                
                    Button {
                        goToBillDetails = true
                    } label: {
                        Image(systemName: "note.text")             .resizable()
                            .frame(width: 20, height: 20)
                    }.buttonStyle(.plain)
                
            }
        }
        .sheet(isPresented: $goToBillDetails, onDismiss: {
            vm.getAllBills()
        }, content: {
            BillDetailsView(vm: vm, bill: bill)
        })
        .sheet(isPresented: $goToEditBill, onDismiss: {
            vm.getAllBills()
        }, content: {
            EditBillView(bill: bill)
        })
        .foregroundColor(.white)
        .bold()
        
        
        .swipeActions {
            Button() {
                self.resetDueDate()
            } label: {
                Text("Mark Paid")
            }.tint(.green).opacity(100)
        }
        
        .swipeActions {
            Button(role: .none) {
                self.goToEditBill = true
            } label: {
                Image(systemName: "pencil")
            }.tint(.gray)
        }
    }
    func getTextColor(for dueDate: Date) -> Color {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let dueDateComponents = calendar.dateComponents([.year, .month, .day], from: dueDate)
        if let currentYear = currentComponents.year,
           let currentMonth = currentComponents.month,
           let currentDay = currentComponents.day,
           let dueYear = dueDateComponents.year,
           let dueMonth = dueDateComponents.month,
           let dueDay = dueDateComponents.day {

            if currentYear > dueYear || (currentYear == dueYear && currentMonth > dueMonth) || (currentYear == dueYear && currentMonth == dueMonth && currentDay > dueDay) {
                return .red
            } else {
                return .mint
            }
        }
        return .mint
    }
}

extension BillTable {
    func resetDueDate () {
        if bill.isRecurringMonthly == 1 && bill.isQuarterly == 0 && bill.isRecurringYearly == 0 {
            vm.resetBillWithMonthlyOption(bill)
            actionMarkPaid()
        } else if bill.isQuarterly == 1 && bill.isRecurringMonthly == 0 && bill.isRecurringYearly == 0 {
            vm.resetBillWithQuaterlyOption(bill)
            actionMarkPaid()
        } else if bill.isRecurringYearly == 1 && bill.isRecurringMonthly == 0 && bill.isQuarterly == 0 {
            vm.resetBillWithAnnualOption(bill)
            actionMarkPaid()
        } else {
            guard bill.isRecurringMonthly == 0 && bill.isQuarterly == 0 && bill.isRecurringYearly == 0 else {return}
            vm.deleteBill(bill)
            actionMarkPaid()
        }
    }
}

struct PayDayView: View {
    let payDate: Date
    var body: some View {
        HStack {
            Image(systemName: "dollarsign")
                .padding(.leading)
            Text("Paydate: \(payDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.headline)
                .bold()
                .padding(.trailing)
                .foregroundStyle(Color.black)
        }
        .background() {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.green)
        }
    }
}

struct BillDetailsView: View {
    @StateObject var vm: BillsListViewModel
    @Environment(\.dismiss) var dismiss
    @State var showWarning: Bool = false
    @State var goToEditBill: Bool = false
    
    let bill: BillModel
    var body: some View {
        ZStack {
            Color.clearLightGray
                .edgesIgnoringSafeArea(.all).opacity(1)
            
            VStack(spacing: 16) {
                Text(bill.title)
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.white)
                    Text(bill.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .foregroundStyle(Color.black)
                }
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundStyle(Color.black, Color.white)
                    Text(bill.amount.with2Decimals().withCommaSeparator())
                        .foregroundStyle(Color.black)
                }
                
                if let details = bill.details {
                    Rectangle()
                        .foregroundColor(.clearLightGray)
                        .cornerRadius(8)
                        .overlay(
                            ScrollView(showsIndicators: false) {
                                Text(details)
                                    .foregroundColor(.black)
                                    .padding()
                            }).shadow(radius: 5)
                        .frame(minWidth: 300, maxWidth: 300, minHeight: 200, maxHeight: 200)
                }
                
                Spacer()
                
                Button {
                    self.goToEditBill = true
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "pencil.and.scribble")
                            .resizable()
                            .frame(minWidth: 30, maxWidth: 35, minHeight: 25, maxHeight: 25)
                        Text("Edit")
                            .font(.subheadline)
                    }.foregroundStyle(Color.white)
                    .padding()
                        .background() {
                        Circle()
                            .foregroundStyle(Color.clearLightGray)
                            .frame(minWidth: 70, maxHeight: 70)
                            .shadow(radius: 10)
                    }
                }
                
                
                if !showWarning {
                    Button {
                        withAnimation {
                            self.showWarning = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Delete Bill")
                                .padding()
                        }
                        .foregroundStyle(Color.red)
                    }
                } else if showWarning == true {
                    VStack {
                        Button {
                            vm.deleteBill(bill)
                            vm.getAllBills()
                            dismiss.callAsFunction()
                        } label: {
                            HStack {
                                Text("Confirm Deletion")
                                    .padding(.leading)

                                Image(systemName: "trash.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding()
                            }.foregroundColor(.red)
                        }
                    }
                }
            }
        }.sheet(isPresented: $goToEditBill, onDismiss: {
            NotificationManager.shared.sendPushNotifications()
            vm.getAllBills()
        }, content: {
            EditBillView(bill: bill)
        })
        .onTapGesture {
            withAnimation {
                showWarning = false
            }
        }
    }
}




struct BillsListView_Previews: PreviewProvider {
    static var previews: some View {
        BillsListView()
    }
}

