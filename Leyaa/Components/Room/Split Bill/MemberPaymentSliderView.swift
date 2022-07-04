//
//  MemberPaymentSliderView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/4/22.
//

import Foundation

import SwiftUI

struct MemberPaymentSliderView: View {
 
    @State var userID: String
    @State var avatar = "ketchup"
    @State var name = "Default Name"
    @Binding var maxAmount: Double
    @Binding var memberAmount: [Double]
    
    @State private var isEditing = false
    @Binding var currentAmount: Double
    @State var index: Int
    @State private var isShowingTextField: Bool = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        
        
        VStack {
            
            //Top Layer Without Manual Control
            HStack {
                
                //Avatar and Name
                VStack{
                    Image(avatar).resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(width: 50, height: 50).clipShape(Circle())
                    
                    Text(name).font(.caption)
                    
                }
                
                Spacer()
                
                //Slider
                VStack (alignment: .trailing) {
                    if maxAmount>0 {
                        
                        Slider(
                            value: $currentAmount,
                            in: 0...maxAmount,
                            step: 1
                        ) { Text("") }
                    minimumValueLabel: { Text("") }
                    maximumValueLabel: { Text(String(currentAmount.magnitude)) }
                    onEditingChanged: { data in
                        if data == false {
                            memberAmount[index] = currentAmount
                        }
                    }

                        
                        
                    }
                    
                    else {
                        
                        Slider(
                            value: $currentAmount,
                            in: 0...0.01,
                            step: 0.001
                        )
                            { Text("") }
                            minimumValueLabel: { Text("") }
                            maximumValueLabel: {
                            Text("Invalid Amount")
                        }
                            onEditingChanged: { data in
                                print(data)
                                // execute more code here
                              }
                        
                    }
                }
                .frame(width: screenWidth*0.65)
                
                
                //Chevron button
                Button {
                    withAnimation(.easeInOut) {
                        isShowingTextField.toggle()
                    }
                    print(memberAmount)
                } label: {
                    Image(systemName: "pencil.circle").resizable().frame(width: 20, height: 20)
                }
                
                
            }
            
            //Bottom Layer With Manual Control
            HStack {
                    
                    Spacer()
                    
                    if isShowingTextField {

                        
                        TextField("Amount", value: $currentAmount, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .autocapitalization(.none)
                            .foregroundColor(.blue)
                            .disableAutocorrection(true)
                            .tint(.blue)
                        
                        Button {
                            withAnimation(.easeInOut) {
                                isShowingTextField.toggle()
                            }
                        } label: {
                            Image(systemName: "arrow.up.circle")
                                .resizable()
                                .scaledToFit()
                                .frame (width: 20, height: 20)
                        }.padding(.leading, 10)

                        
                    }
                    
                }
            
        }
        .padding(.horizontal, 10)
        
        .onAppear(perform: {
            viewModel.getProfileAvatar(userID: userID) { res in self.avatar = res }
            viewModel.getProfileName(userID: userID) { res in self.name = res }
          
        })
    }
}

struct MemberPaymentSliderView_Previews: PreviewProvider {
    static var previews: some View {
        MemberPaymentSliderView(userID: "1234", maxAmount: .constant(200), memberAmount: .constant([1.2, 1.5, 2.4]), currentAmount: .constant(40.0), index: 2).environmentObject(AuthViewModel())
    }
}
