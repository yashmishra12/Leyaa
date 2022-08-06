//
//  BillEditView.swift
//  Leyaa
//
//  Created by Yash Mishra on 8/6/22.
//

import SwiftUI


struct BillEditView: View {
    @State var billTitle: String
    @State var billAmount: Double
    @State var id: String
    @State var roomID: String
    
    let billManager = BillManager()
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState var titleIsFocused
    @FocusState var priceIsFocused
    
    func donePressed() {
        if billTitle.isEmpty == false {
            billManager.editBill(roomID: roomID, billID: id, billTitle: billTitle, billAmount: billAmount)
            successSB(title: "Successful")
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        VStack{
            Image("editItem").resizable().aspectRatio(contentMode: .fit).padding(.top, -20)
            
            VStack (spacing: 20) {
                CustomInputField(imageName: "circle.hexagonpath",
                                 placeholderText: "New Name",
                                 isSecureField: false,
                                 text: $billTitle)
                    .focused($titleIsFocused)
                    .submitLabel(.next)
                    .onSubmit {
                        priceIsFocused = true
                    }
                   
            
                    HStack{
                        Image (systemName: "dollarsign.circle")
                            .resizable()
                            .scaledToFit()
                            .frame (width: 20, height: 20)
                            .foregroundColor (Color("MediumBlue"))
                            .padding(.trailing, 15)
                        
                        
                        TextField("$ is needed. Hit Done on keypad.", value: $billAmount, formatter: formatterAmount)
                            .focused($priceIsFocused)
                            .keyboardType(.decimalPad)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .onSubmit {
                                donePressed()
                            }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button {
                                        priceIsFocused = false
                                        titleIsFocused = false
                                        
                                    } label: {
                                        Text("Done")
                                    }.buttonStyle(.plain)
                                    
                                }
                            }
                        
                        
                    }
                    Divider()
                        .background(Color("LightBlue"))

                
            }.padding()
               
            
            VStack{
                Button {
                    donePressed()
                } label: {
                    Text("Save").buttonStyleBlue()
                }.buttonStyle(.plain)
                    .disabled(billTitle.isEmpty)
                
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                    self.titleIsFocused = true
                }
            }
        }
    }
}

//struct BillEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        BillEditView()
//    }
//}
