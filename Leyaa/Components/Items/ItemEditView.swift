//
//  ItemEditView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/26/22.
//

import SwiftUI
import Focuser
import NotificationBannerSwift

enum FormFields {
    case name, quantity, description
}


extension FormFields: FocusStateCompliant {

    static var last: FormFields {
        .description
    }

    var next: FormFields? {
        switch self {
        case .name:
            return .quantity
        case .quantity:
            return .description
        default: return nil
        }
    }
}


struct ItemEditView: View {
    @State var item: Item
    
    @EnvironmentObject var viewModel: AuthViewModel
    @FocusStateLegacy var focusedFieldEdit: FormFields?
    
    @State var name: String
    @State var desc: String
    @State var qty: String
    @State var roomID: String
    @Binding var offset: CGSize
    
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        
        VStack{
            Image("editItem").resizable().aspectRatio(contentMode: .fit).padding(.top, -20)
            
            VStack (spacing: 20) {
                CustomInputField(imageName: "circle.hexagonpath", placeholderText: "Name", isSecureField: false, text: $name)
                    .focusedLegacy($focusedFieldEdit, equals: .name)
                
                CustomInputField(imageName: "number", placeholderText: "Quantity", isSecureField: false, text: $qty)
                    .focusedLegacy($focusedFieldEdit, equals: .quantity)
            
                
                CustomInputField(imageName: "text.quote", placeholderText: "Description", isSecureField: false, text: $desc)
                    .focusedLegacy($focusedFieldEdit, equals: .description)
                
            }.padding()
            
            VStack{
                Button {
                    viewModel.editItem(item: item, name: name, qty: qty, desc: desc, roomID: roomID)
                    
                    let banner = StatusBarNotificationBanner(title: "Edited", style: .info)
                    banner.show()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { 
                        banner.dismiss()
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save").buttonStyle()
                }.buttonStyle(.plain)
            }
            
        }.onAppear {
            offset.width = 0
        }
        
       

    }
}
