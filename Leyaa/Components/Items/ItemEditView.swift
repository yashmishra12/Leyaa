//
//  ItemEditView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/26/22.
//

import SwiftUI

struct ItemEditView: View {
    @State var item: Item
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var name: String
    @State var desc: String
    @State var qty: String
    @State var roomID: String

    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        VStack{
            CustomInputField(imageName: "bookmark.fill", placeholderText: "Name", isSecureField: false, text: $name)
//                .focused(T##condition: FocusState<Bool>.Binding##FocusState<Bool>.Binding)
            
            CustomInputField(imageName: "bookmark.fill", placeholderText: "Quantity", isSecureField: false, text: $qty)
        
            
            CustomInputField(imageName: "bookmark.fill", placeholderText: "Description", isSecureField: false, text: $desc)
            
            VStack{
                Button {
                    viewModel.editItem(item: item, name: name, qty: qty, desc: desc, roomID: roomID)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
            }
            
        }
        
       

    }
}

//struct ItemEditView_Previews: PreviewProvider {
//    static var previews: some View {
//       ItemEditView(
//    }
//}
