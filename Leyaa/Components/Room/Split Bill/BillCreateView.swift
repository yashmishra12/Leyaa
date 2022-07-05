//
//  BillCreateView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/4/22.
//

import SwiftUI


let formatterAmount: NumberFormatter = {
       let formatter = NumberFormatter()
       formatter.numberStyle = .decimal
       return formatter
   }()


struct BillCreateView: View {

    
    @Binding var roomData: Room
    @State var billAmount: Double = 0

    @State var itemName: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State var memberAmount: [Double]
    @FocusState private var priceIsFocused: Bool
    @FocusState private var nameIsFocused: Bool
    
    @FocusState private var isEditing: Bool
    
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
                            

                            TextField("Amount", value: $billAmount, formatter: formatterAmount)
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
                            memberAmount[index] = Double(billAmount) / Double(roomData.members.count)
                        }
                    } label: {
                        Text("Equal Split")
                            .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(Color("MediumBlue"))
                                .clipShape(Capsule())
                                
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    
                    
                    Button {
                        for index in 0..<roomData.members.count {
                            memberAmount[index] = 0.0
                        }
                        
                    } label: {
                        Text("Set All Zero")
                            .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(Color("MediumBlue"))
                                .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    
                }
               
                Divider().padding()

                
                ScrollView{
                    ForEach(0..<roomData.members.count, id: \.self) { i in
                        MemberPaymentSliderView(userID: roomData.members[i],
                                                maxAmount: $billAmount,
                                                memberAmount: $memberAmount,
                                                currentAmount: $memberAmount[i],
                                                index: i, isEditing: $isEditing)
                    }
                }
                
                // Save Button
                HStack {
                    
                    Button {
                        let itemName: String = itemName
                        let itemPrice: Double = billAmount
                        let payer: String = viewModel.currentUser?.id ?? ""
                        
                        var contributors: [String : Double] = [:]
                        
                        for index in 0..<roomData.members.count {
                            contributors[roomData.members[index]] = memberAmount[index]
                        }
                        
                        print("Item Name: \(itemName)")
                        print("Item Price: \(itemPrice)")
                        print("Payer: \(payer)")
                        print("contributors: \(contributors)")
                        
                    } label: {
                        Text("Save")
                            .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(Color("MediumBlue"))
                                .clipShape(Capsule())
                    }
                    .disabled(memberAmount.reduce(0, +) != billAmount || itemName.isEmpty)
                    .opacity(memberAmount.reduce(0, +) != billAmount || itemName.isEmpty ? 0.3 : 1.0)
        
                    .padding(.bottom, 15)
                    .buttonStyle(.plain)
                    
                    
                }
            
        }
        
    }
}


struct BillCreateView_Previews: PreviewProvider {
    static var previews: some View {
        BillCreateView(roomData: .constant(Room(id: "123", title: "Avent Ferry", newItems: [], members: [])), memberAmount: [0])
    }
}


class UITextFieldWithDoneButton: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addDoneButtonOnKeyboard()
    }

    fileprivate func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc fileprivate func doneButtonAction() {
        self.resignFirstResponder()
    }
}
