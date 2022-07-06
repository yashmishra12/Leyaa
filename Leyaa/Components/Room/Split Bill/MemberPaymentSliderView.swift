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
    
    @Binding var currentAmount: Double
    @State var index: Int
    @State private var isShowingTextField: Bool = false
    
    var isEditing: FocusState<Bool>.Binding
    
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
                        
                        HStack {
                            Spacer()
                            
                            Slider(
                                value: $currentAmount,
                                in: 0...maxAmount,
                                step: 1
                            ) { Text("") }
                        minimumValueLabel: { Text("") }
                        maximumValueLabel: { Text("") }
                        onEditingChanged: { data in
                            if data == false {
                                memberAmount[index] = currentAmount
                                }
                            }
                            
                            TextField("Amt.", value: $currentAmount, formatter: formatterAmount)
                                .font(.footnote)
                                .focused(isEditing)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .autocapitalization(.none)
                                .foregroundColor(.blue)
                                .frame(minWidth: 35, idealWidth: 35, maxWidth: 80)
                                .padding(.trailing, 5)
                            }
                        }
                    
                    else {
                        
                        HStack {
                            Spacer()
                            
                            Slider(
                                value: $currentAmount,
                                in: 0...0.01,
                                step: 0.001
                            )
                                { Text("") }
                                minimumValueLabel: { Text("") }
                                maximumValueLabel: {
                                    Text("X")
                            }
                            
                        }.padding(.trailing, 10)
                        
                        
                    }
                }
                .frame(width: screenWidth*0.80)



            }
               
        }
        .padding(.horizontal, 10)
        
        .onAppear(perform: {
            viewModel.getProfileAvatar(userID: userID) { res in self.avatar = res }
            viewModel.getProfileName(userID: userID) { res in self.name = res }
          
        })
    }
}


//struct MemberPaymentSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemberPaymentSliderView(userID: "1234", maxAmount: .constant(200), memberAmount: .constant([1.2, 1.5, 2.4]), currentAmount: .constant(40.0), index: 2, isEditing: .constant(false)).environmentObject(AuthViewModel())
//    }
//}
