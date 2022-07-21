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
    
    func donePressed() {
        if name.isEmpty == false {
            viewModel.editRoomName(newName: name, roomID: roomData.id ?? "")
            successSB(title: "Name Changed")
            isShowingSideMenu.toggle()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
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
                    .submitLabel(.done)
                    .onSubmit {
                        donePressed()
                    }
                
            }.padding()
               
            
            VStack{
                Button {
                    donePressed()
                } label: {
                    Text("Save").buttonStyleBlue()
                }.buttonStyle(.plain)
                    .disabled(name.isEmpty)
                
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
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
