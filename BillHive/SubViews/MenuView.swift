//
//  MenuView.swift
//  BillHive
//
//  Created by Julian Burton on 7/4/23.
//

import SwiftUI

struct MenuView: View {
    @StateObject var vm: MenuViewViewModel = MenuViewViewModel()
    @State var seguedFrom: SeguedFrom = .billListView
    @Environment (\.dismiss) var dismiss
    var completion: ( () -> ()?)?
    var body: some View {
        ZStack {
            Color.clearLightGray.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                goToInfoViewButton
                supportLink
//                exportToPDFButton
            }
        }.preferredColorScheme(.light)
        .sheet(isPresented: $vm.goToInfoView, onDismiss: {
            dismiss.callAsFunction()
        }, content: {
            InfoViewFromList(completion: completion)
        })
    }
}

extension MenuView {
    var goToInfoViewButton: some View {
        HStack {
            Button {
                vm.goToInfoView = true
            } label: {
                Text("Enter next paydate")
                    .padding(10)
                    .foregroundColor(.white)
                    .bold()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.black).opacity(0.35)
                    )
                    .shadow(radius: 5)
            }
        }
    }
    
    var supportLink: some View {
        HStack {
            Button {
                guard let url = URL(string: "https://sites.google.com/view/billhivepp?usp=sharing") else {return}
                UIApplication.shared.open(url)
            } label: {
                Text("Support")
                    .bold()
                    .padding(10)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.black).opacity(0.35)
                    )
                    .shadow(radius: 5)
            }

        }
    }
    
    var exportToPDFButton: some View {
        HStack {
            Button {
                //EXPORT
            } label: {
                Text("Export bills to PDF file")
                    .bold()
                    .padding(10)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.black).opacity(0.35)
                    )
                    .shadow(radius: 5)
            }

        }
    }
    
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
