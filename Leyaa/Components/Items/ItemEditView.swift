//
//  ItemEditView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/26/22.
//

import SwiftUI
import NotificationBannerSwift



struct ItemEditView: View {
    @State var item: Item
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @FocusState private var nameIsFocused: Bool
    @FocusState private var qtyIsFocused: Bool
    @FocusState private var descIsFocused: Bool
    
    @State var name: String
    @State var desc: String
    @State var qty: String
    @State var roomID: String
    
    
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        
        VStack{
            Image(name.sanitiseItemName()).resizable().aspectRatio(contentMode: .fit).frame(width: 200, height: 200, alignment: .center)
                .shadow(color: .blue, radius: 1, x: 0, y: 0)
            
            VStack (spacing: 20) {
                CustomInputField(imageName: "circle.hexagonpath", placeholderText: "Name", isSecureField: false, text: $name)
                    .focused($nameIsFocused)
                    .onSubmit {
                        qtyIsFocused = true
                    }
                    .submitLabel(.next)

                
                CustomInputField(imageName: "number", placeholderText: "Quantity", isSecureField: false, text: $qty)
                    .focused($qtyIsFocused)
                    .onSubmit {
                        descIsFocused = true
                    }.submitLabel(.next)

            
                
                CustomInputField(imageName: "text.quote", placeholderText: "Description", isSecureField: false, text: $desc)
                    .focused($descIsFocused)
                    .onSubmit {
                        descIsFocused = false
                    }
                    .submitLabel(.done)

                
            }.padding()
                .padding(.top)
            
            VStack{

                Button {
                    descIsFocused = false
                    nameIsFocused = false
                    qtyIsFocused = false
                    
                    viewModel.editItem(item: item, name: name, qty: qty, desc: desc, roomID: roomID)
                    
                    infoSB(title: "Edited")
                    
                    presentationMode.wrappedValue.dismiss()
                
                } label: {
                    Text("Save").buttonStyle()
                }.buttonStyle(.plain)
            }
            
        }
        .onAppear {
            nameIsFocused = true
        }

    }
}
