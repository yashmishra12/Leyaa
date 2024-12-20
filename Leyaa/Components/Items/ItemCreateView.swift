//
//  ItemCreateView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/22/22.
//

import SwiftUI


struct ItemCreateView: View {
    @State var name: String
    @State var qty: String 
    @State var desc: String

    let itemManager = ItemManager()
    
    @Binding var roomData: Room
    @FocusState private var nameFocus: Bool
    @FocusState private var qtyFocus: Bool
    @FocusState private var descFocus: Bool
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    func donePressed() {
        descFocus = false
        let item = ["id": UUID().uuidString ,"name": name, "desc": desc, "qty": qty]
        
        if name.isEmpty==false {
            itemManager.addItem(item: item, roomID: roomData.id ?? "")
            name = ""
            qty = ""
            desc = ""
            
            nameFocus = true
            
            successSB(title: "Added")
            
            hapticFeedback.notificationOccurred(.success)
        }
        else {
            nameFocus = true
        }
    }
    
    var body: some View {
        VStack {
            if name.isEmpty {
                Image("addItem").resizable().frame(width: 200, height: 200)
            }
            else {
                Image(name.sanitiseItemName()).resizable().frame(width: 200, height: 200).shadow(color: .blue, radius: 1, x: 0, y: 0)
            }
            
            VStack {
                CustomInputField(imageName: "circle.hexagonpath", placeholderText: "Item Name", isSecureField: false, text: $name).padding()
                    .focused($nameFocus)
                    .onSubmit {
                        qtyFocus = true
                    }
                    .submitLabel(.next)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                donePressed()
                            } label: {
                                Text("Save")
                            }.buttonStyle(.plain)
                            
                        }
                    }

                
                CustomInputField(imageName: "number", placeholderText: "Quantity", isSecureField: false, text: $qty).padding()
                    .focused($qtyFocus)
                    .onSubmit {
                        descFocus = true
                    }
                    .submitLabel(.next)
                
                
                CustomInputField(imageName: "text.quote", placeholderText: "Description", isSecureField: false, text: $desc).padding()
                    .focused($descFocus)
                    .submitLabel(.done)
                    .onSubmit {
                        donePressed()
                    }
                                   
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                    nameFocus = true
                }
            }
            
            
            Button {
                donePressed()
                
            } label: {
                Text("Add Item").buttonStyleBlue()
            }.buttonStyle(.plain)
                .disabled(name.isEmpty)
        }.navigationBarTitleDisplayMode(.inline)
        
    }
}

struct ItemCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCreateView(name: "", qty: "", desc: "",
                       roomData: .constant(Room(id: "", title: "", newItems: [Item(id: "", name: "", desc: "", qty: "")], members: [""])))
    }
}
