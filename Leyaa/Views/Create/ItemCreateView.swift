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
    @State var assignedTo: String
    @Binding var roomData: Room
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            CustomInputField(imageName: "circle.hexagonpath", placeholderText: "Item", isSecureField: false, text: $name)
            
            CustomInputField(imageName: "circle.hexagonpath", placeholderText: "qty", isSecureField: false, text: $qty)
            
            CustomInputField(imageName: "circle.hexagonpath", placeholderText: "desc", isSecureField: false, text: $desc)
            
            CustomInputField(imageName: "circle.hexagonpath", placeholderText: "assignedTo", isSecureField: false, text: $assignedTo)
        }
        
        
        Button {
            let item = ["id": UUID().uuidString ,"name": name, "desc": desc, "qty": qty, "assignedTo": assignedTo]
            viewModel.addItem(item: item, roomID: roomData.id ?? "")
            
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Add Item")
        }
        
    }
}

struct ItemCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCreateView(name: "", qty: "", desc: "", assignedTo: "",
                       roomData: .constant(Room(id: "", title: "", newItems: [Item(id: "", name: "", desc: "", qty: "", assignedTo: "")], members: [""])))
    }
}
