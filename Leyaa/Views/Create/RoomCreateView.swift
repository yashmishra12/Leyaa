//
//  CreateRoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI
import Firebase

struct RoomCreateView: View {
    @State var roomName: String = ""
    var db = Firestore.firestore()
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            Image("createRoom")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, -100)
            
            CustomInputField(imageName: "house.fill", placeholderText: "Room Name", isSecureField: false, text: $roomName)
                .padding()

            let newRoom = Room(title: roomName, newItems: [], members: [ (Auth.auth().currentUser?.uid ?? "") + ""])
        
            
            Button {
                viewModel.addRoom(room: newRoom)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Create Room")
                    .font (.headline)
                    .foregroundColor (.white)
                    .padding()
                    .background(Color("MediumBlue"))
                    .clipShape(Capsule())
                    .padding ()
                    
            }.buttonStyle(.plain)

            
        }
        
    }
}

struct RoomCreateView_Previews: PreviewProvider {
    static var previews: some View {
        RoomCreateView(roomName: "")
    }
}
