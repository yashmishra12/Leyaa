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
    
    @FocusState var roomNameIsFocused: Bool
    
    func donePressed() {
        if roomName.isEmpty == false {
            let newRoom = Room(title: roomName, newItems: [], members: [ (Auth.auth().currentUser?.uid ?? "") + ""])
        
            viewModel.addRoom(room: newRoom)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        
        VStack {
            Image("createRoom")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, -100)
            
            CustomInputField(imageName: "house.fill", placeholderText: "Room Name", isSecureField: false, text: $roomName)
                .padding()
                .submitLabel(.done)
                .focused($roomNameIsFocused)
                .onSubmit {
                   donePressed()
                }
        
            
            Button {
                donePressed()
            } label: {
                Text("Create Room").buttonStyleBlue()
                    
            }.buttonStyle(.plain)
                .disabled(roomName.isEmpty)


            
        }.navigationBarTitleDisplayMode(.inline)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                    self.roomNameIsFocused = true
                }
            }
        
    }
}

struct RoomCreateView_Previews: PreviewProvider {
    static var previews: some View {
        RoomCreateView(roomName: "")
    }
}
