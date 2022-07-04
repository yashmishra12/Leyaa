//
//  BillCreateView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/4/22.
//

import SwiftUI

struct BillCreateView: View {
    @Binding var roomData: Room
    @State var billAmount: Double = 100
    @State var itemName: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State var memberAmount: [Double]

    
    var body: some View {
        VStack  {
            
            //MARK: - Input Fields
            VStack {
                CustomInputField(imageName: "circle.hexagonpath", placeholderText: "Item Name", isSecureField: false, text: $itemName)
                    .padding()
                
                
                VStack {
                    HStack{
                        Image (systemName: "dollarsign.circle")
                            .resizable()
                            .scaledToFit()
                            .frame (width: 20, height: 20)
                            .foregroundColor (Color("MediumBlue"))
                            .padding(.trailing, 15)
                        
                        
                        TextField("Amount", value: $billAmount, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                    }
                    Divider()
                        .background(Color("LightBlue"))
                    
                }.padding()
                
                //MARK: - Horizontal Buttons
                HStack {
                    Button {
                        for index in 0..<roomData.members.count {
                            memberAmount[index] = Double(billAmount) / Double(roomData.members.count)
                        }
                    } label: {
                        Text("Equal Split")
                            .font (.headline)
                            .padding()
                            .foregroundColor (.white)
                    }
                    .background(Color("MediumBlue"))
                    .cornerRadius(25)
                    .padding()
                    
                    Button {
                        
                        for index in 0..<roomData.members.count {
                            memberAmount[index] = 0.0
                        }
                        
                    } label: {
                        Text("Set All Zero")
                            .font (.headline)
                            .padding()
                            .foregroundColor (.white)
                    }
                    .background(Color("MediumBlue"))
                    .cornerRadius(25)
                    .padding()
                    
                }
                Spacer()
                
                ScrollView{
                    ForEach(0..<roomData.members.count, id: \.self) { i in
                        MemberPaymentSliderView(userID: roomData.members[i],
                                                maxAmount: $billAmount,
                                                memberAmount: $memberAmount,
                                                currentAmount: $memberAmount[i],
                                                index: i)
                    }
                }
                
                
                HStack {
                    Button {
                        
                        
                    } label: {
                        Text("Save")
                            .font (.headline)
                            .padding()
                            .foregroundColor (.white)
                    }
                    .disabled(memberAmount.reduce(0, +) != billAmount || itemName.isEmpty)
                    .opacity(memberAmount.reduce(0, +) != billAmount || itemName.isEmpty ? 0.3 : 1.0)
                    .background(Color("MediumBlue"))
                    .cornerRadius(25)
                    .padding(.bottom, 5)
                    
                    
                }
            }
        }
        
    }
    
    
}

struct BillCreateView_Previews: PreviewProvider {
    static var previews: some View {
        BillCreateView(roomData: .constant(Room(id: "123", title: "Avent Ferry", newItems: [], members: [])), memberAmount: [0])
    }
}


