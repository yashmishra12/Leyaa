//
//  BillCreateView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/4/22.
//

import SwiftUI


let formatterAmount: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
       return formatter
   }()


struct BillCreateView: View {

    
    @Binding var roomData: Room
    @State var billAmount: Double?

    @State var itemName: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State var memberAmount: [Double]
    @FocusState private var priceIsFocused: Bool
    @FocusState private var nameIsFocused: Bool
    
    @FocusState private var isEditing: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack  {
               
                //MARK: - Input Fields
                VStack {
                    
                    //MARK: - Item Name
                    VStack {
                        HStack{
                            Image (systemName: "circle.hexagonpath")
                                .resizable()
                                .scaledToFit()
                                .frame (width: 20, height: 20)
                                .foregroundColor (Color("MediumBlue"))
                                .padding(.trailing, 15)
                            
                            
                            TextField("Item Name", text: $itemName)
                                .autocapitalization(.none)
                                .focused($nameIsFocused)
                                .disableAutocorrection(true)
                            
                        }
                      
                        
                        Divider()
                            .background(Color("LightBlue"))
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    
                    
                    
                    //MARK: - Item Price
                    VStack {
                        HStack{
                            Image (systemName: "dollarsign.circle")
                                .resizable()
                                .scaledToFit()
                                .frame (width: 20, height: 20)
                                .foregroundColor (Color("MediumBlue"))
                                .padding(.trailing, 15)
                            

                            TextField("Bill Amount", value: $billAmount, formatter: formatterAmount)
                                                                .focused($priceIsFocused)
                                                                .keyboardType(.decimalPad)
                                                                .autocapitalization(.none)
                                                                .disableAutocorrection(true)
                                                                .toolbar {
                                                                    ToolbarItemGroup(placement: .keyboard) {
                                                                        Spacer()
                                                                        Button {
                                                                            priceIsFocused = false
                                                                            nameIsFocused = false
                                                                            isEditing = false
                                                                        } label: {
                                                                            Text("Done")
                                                                        }.buttonStyle(.plain)
                                
                                                                    }
                                                                }

                            
                        }
                        Divider()
                            .background(Color("LightBlue"))
                        
                    }.padding()
                    
                }
                
                //MARK: - Horizontal Buttons
                HStack {
                    Button {
                        for index in 0..<roomData.members.count {
                            memberAmount[index] = Double(billAmount ?? 0) / Double(roomData.members.count)
                        }
                    } label: {
                        Text("Equal Split").buttonStyle()
                                
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    
                    
                    Button {
                        for index in 0..<roomData.members.count {
                            memberAmount[index] = 0.0
                        }
                        
                    } label: {
                        Text("Set All Zero").buttonStyle()
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    
                }
               
            //MARK: - Remaining Balance Info
            Text("Remaining Balance: \(String(format: "%.2f", (billAmount ?? 0)-memberAmount.reduce(0, +)))")
                .font(.caption)
                .padding(.top, 15)
            
            
                Divider().padding()
                .padding(.top, -5)

                
                ScrollView{
                    ForEach(0..<roomData.members.count, id: \.self) { i in
                        MemberPaymentSliderView(userID: roomData.members[i],
                                                maxAmount: $billAmount,
                                                memberAmount: $memberAmount,
                                                currentAmount: $memberAmount[i],
                                                index: i, isEditing: $isEditing).padding(.bottom, 15)
                    }
                }
                
            if (memberAmount.reduce(0, +)==billAmount && itemName.isEmpty) {
                Text("Item Name not set.").font(.caption2)
            }
            
            if (memberAmount.reduce(0, +) == 0 && billAmount == 0) {
                Text("Zero Dollar Bill").font(.caption2)
            }
                // Save Button
                HStack {
                    
                    Button {

                        var contributors: [String : Double] = [:]
                        
                        for index in 0..<roomData.members.count {
                            contributors[roomData.members[index]] = memberAmount[index]
                        }
                        
                        
                        for (contributorID, contributionAmount) in contributors {
                            if contributorID != viewModel.currentUser?.id && contributionAmount != 0 {
                                let newBill = Bill(itemName: itemName, itemPrice: contributionAmount, payer: viewModel.currentUser?.id ?? "", contributor: contributorID, timestamp: Date())
                                
                                viewModel.addNewBill(bill: newBill, roomID: roomData.id ?? "")
                            }
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Text("Save").buttonStyle()
                    }
                    .disabled(memberAmount.reduce(0, +) != billAmount || itemName.isEmpty || memberAmount.reduce(0, +) == 0)
                    .opacity(memberAmount.reduce(0, +) != billAmount || itemName.isEmpty ? 0.5 : 1.0)
        
                    .padding(.bottom, 15)
                    .buttonStyle(.plain)
                    
                    
                }
            
        }
        
    }
}


struct BillCreateView_Previews: PreviewProvider {
    static var previews: some View {
        BillCreateView(roomData: .constant(Room(id: "123", title: "Avent Ferry", newItems: [], members: [])), billAmount: 90, memberAmount: [0])
    }
}



