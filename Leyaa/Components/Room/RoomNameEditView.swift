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
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Image("editItem").resizable().aspectRatio(contentMode: .fit).padding(.top, -20)
            
            VStack (spacing: 20) {
                CustomInputField(imageName: "circle.hexagonpath", placeholderText: "New Name", isSecureField: false, text: $name)
                
            }.padding()
            
            VStack{
                Button {
                    viewModel.editRoomName(newName: name, roomID: roomData.id ?? "")
                    let banner = StatusBarNotificationBanner(title: "Name Changed", style: .success)
                    banner.show()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                        banner.dismiss()
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save").buttonStyle()
                }.buttonStyle(.plain)
                
            }
            
        }
    }
}

//struct RoomNameEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomNameEditView(name: "", roomData: "")
//    }
//}
