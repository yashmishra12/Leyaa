//
//  RoomInviteView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/25/22.
//

import SwiftUI

struct RoomInviteView: View {
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var message = ""
    @State private var fullname = ""
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
            CustomInputField(imageName: "envelope", placeholderText: "Message", text: $message)
        }.padding()
        

        Button {
        
            viewModel.roomInvite(recieverEmail: email, message: message, roomData: roomData)
            
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Send Invite").foregroundColor(.white)
        }

        
    }
}

struct RoomInviteView_Previews: PreviewProvider {
    static var previews: some View {
        RoomInviteView(roomData: .constant(Room(title: "", newItems: [], members: [])))
    }
}
