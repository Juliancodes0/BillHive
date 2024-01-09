//
//  EditBillView.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import SwiftUI

struct EditBillView: View {
    let bill: BillModel
    @StateObject var vm: EditBillViewModel = EditBillViewModel()
    @Environment(\.dismiss) var dismiss
    @State var showNoButton: Bool = true
    @State var reshowNoButton: Bool = false
    var body: some View {
        ZStack {
            Color.clearLightGray.edgesIgnoringSafeArea(.all)
            VStack(spacing: 8) {
                
                TextField("Bill", text: $vm.title)
                    .foregroundColor(.black)
                    .frame(minWidth: 200, maxWidth: 200)
                    .padding(8)
                    .background() {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                    }
      
                TextField("Amount", text: Binding<String>(
                    get: { "$" + vm.amount },
                    set: { vm.amount = String($0.dropFirst()) }
                ))
                .foregroundColor(.black)
                .frame(width: 120, height: 30)
                .padding(8)
                .background() {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                }
                .keyboardType(.decimalPad)
                
                VStack(spacing: 10) {
                    
                    Text("Add description below (optional)")
                        .foregroundStyle(Color.black)
                    TextEditor(text: $vm.details)
                        .frame(maxWidth: 230, maxHeight: 80)
                        .foregroundStyle(Color.black)

                    HStack {
                        DatePicker("Due Date", selection: $vm.dueDate, displayedComponents: .date)
                            .frame(width: 230, height: 20)
                            .foregroundColor(.black)
                            .datePickerStyle(.compact)
                            .padding()
                    } .background() {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white).opacity(0.8)
                    }
                }
                
                Text("Is this bill recurring?")
                    .foregroundColor(.black)
                    .shadow(radius: 10)
                HStack {
                    Button {
                        vm.isYesRecurringSelected.toggle(); vm.isRecurringNotSelected = false
                        vm.setAllRecurringOptionsToFalse()
                        withAnimation {
                            showNoButton.toggle()
                        }
                    } label: {
                        Text("Yes")
                            .frame(width: 37, height: 25)
                            .shadow(radius: 10)
                            .padding(5)
                            .foregroundColor(.white)
                            .background() {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(vm.isYesRecurringSelected == true ? .blue.opacity(0.9) : .gray)
                                    .opacity(vm.isYesRecurringSelected == true ? 1 : 0.8)
                            }
                    }.padding(6.5)
                    
                    if showNoButton == true {
                        Button {
                            vm.isYesRecurringSelected = false; vm.isRecurringNotSelected = true
                        } label: {
                            Text("No")
                                .frame(width: 37, height: 25)
                                .shadow(radius: 10)
                                .padding(5)
                                .foregroundColor(.white)
                                .background() {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(vm.isYesRecurringSelected == false && vm.isRecurringNotSelected == true ? .blue.opacity(0.9) : .gray)
                                        .opacity(vm.isYesRecurringSelected == false && vm.isRecurringNotSelected == true ? 1 : 0.8)
                                }
                        }.padding(6.5) }

                }
                if vm.isYesRecurringSelected {
                    HStack {
                        Button {
                            vm.isMonthly = true
                            vm.isAnnual = false
                            vm.isQuarterly = false
                        } label: {
                            Text("Monthly")
                                .shadow(radius: 10)
                                .padding(8)
                                .foregroundColor(.white)
                                .background() {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(vm.isMonthly ? .blue.opacity(0.9) : .gray)
                                }
                        }
                        
                        Button {
                            vm.isQuarterly = true
                            vm.isMonthly = false
                            vm.isAnnual = false
                        } label: {
                            Text("Quarterly")
                                .shadow(radius: 10)
                                .padding(8)
                                .foregroundColor(.white)
                                .background() {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(vm.isQuarterly ? .blue.opacity(0.9) : .gray)
                                }
                        }
                        
                        Button {
                            vm.isAnnual = true
                            vm.isMonthly = false
                            vm.isQuarterly = false
                        } label: {
                            Text("Annually")
                                .shadow(radius: 10)
                                .padding(8)
                                .foregroundColor(.white)
                                .background() {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(vm.isAnnual ? .blue.opacity(0.9) : .gray)
                            }
                        }
                    }
                }
                Button {
                    vm.editSavedBill(bill: bill.bill)
                    dismiss.callAsFunction()
                } label: {
                    Text("SAVE")
                        .frame(width: 47, height: 24)
                        .padding(10)
                        .shadow(radius: 10)
                        .foregroundColor(.white)
                        .bold()
                        .background() {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(.blue)
                                .opacity(vm.allOptionsRequiredSelected() ? 1 : 0.3)
                        }
                }.disabled(vm.allOptionsRequiredSelected() ? false : true)
            }
            .bold().padding()
        }.onTapGesture(count: 2, perform: {
            //CAN TRY DISMISSING KEYBOARD WITH 2 TAPS
        })
        .preferredColorScheme(.light)
        .onAppear() {
            vm.getOldBillInfo(bill)
        }
    }
}

struct EditBillView_Previews: PreviewProvider {
    static var previews: some View {
        let bill = Bill(context: DataPersistence.shared.persistentContainer.viewContext)
        EditBillView(bill: BillModel(bill: bill))
    }
}
