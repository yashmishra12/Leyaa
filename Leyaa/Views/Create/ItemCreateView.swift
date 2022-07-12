//
//  ItemCreateView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/22/22.
//

import SwiftUI
import Focuser

struct ItemCreateView: View {
    @State var name: String
    @State var qty: String 
    @State var desc: String

    @Binding var roomData: Room
    @FocusState private var nameFocus: Bool
    @FocusState private var qtyFocus: Bool
    @FocusState private var descFocus: Bool
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        VStack {
            Image("addItem").resizable().aspectRatio(contentMode: .fit).padding(.top, -100)
            VStack {
                CustomInputField(imageName: "circle.hexagonpath", placeholderText: "Item Name", isSecureField: false, text: $name).padding()
                    .focused($nameFocus)
                    .onSubmit {
                        qtyFocus = true
                    }
                    .submitLabel(.next)

                
                CustomInputField(imageName: "number", placeholderText: "Quantity", isSecureField: false, text: $qty).padding()
                    .focused($qtyFocus)
                    .onSubmit {
                        descFocus = true
                    }
                    .submitLabel(.next)
                
                CustomInputField(imageName: "text.quote", placeholderText: "Description", isSecureField: false, text: $desc).padding()
                    .focused($descFocus)
                    .onSubmit {
                        descFocus = false
                    }
                    .submitLabel(.done)

                
            }
            
            
            Button {
                let item = ["id": UUID().uuidString ,"name": name, "desc": desc, "qty": qty]
                viewModel.addItem(item: item, roomID: roomData.id ?? "")
                
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Add Item").buttonStyle()
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
