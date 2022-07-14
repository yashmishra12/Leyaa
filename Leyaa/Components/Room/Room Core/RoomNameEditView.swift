//
//  RoomNameEditView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/9/22.
//

import SwiftUI
import NotificationBannerSwift

struct RoomNameEditView: View {
    @State var name: String
    @State var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @FocusState var nameIsFocused: Bool
    @Binding var isShowingSideMenu: Bool
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Image("editItem").resizable().aspectRatio(contentMode: .fit).padding(.top, -20)
            
            VStack (spacing: 20) {
                CustomInputField(imageName: "circle.hexagonpath",
                                 placeholderText: "New Name",
                                 isSecureField: false,
                                 text: $name)
                    .focused($nameIsFocused)
                
            }.padding()
               
            
            VStack{
                Button {
                    viewModel.editRoomName(newName: name, roomID: roomData.id ?? "")
                   
                    successSB(title: "Name Changed")
                    
                    isShowingSideMenu.toggle()
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save").buttonStyle()
                }.buttonStyle(.plain)
                
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
                    self.nameIsFocused = true
                }
            }
            
        }
    }
}

//struct RoomNameEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomNameEditView(name: "", roomData: "")
//    }
//}
