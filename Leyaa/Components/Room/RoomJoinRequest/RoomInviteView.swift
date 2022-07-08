//
//  RoomInviteView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/25/22.
//

import SwiftUI
import Firebase
import FirebaseService
import FirebaseFirestoreSwift
import NotificationBannerSwift

struct RoomInviteView: View {
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var message = ""
    @State private var fullname = ""
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            Image("addMember").resizable().aspectRatio(contentMode: .fit).padding(.top, -100)
            
            VStack{
                CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                CustomInputField(imageName: "message.fill", placeholderText: "Message", text: $message)
            }.padding()
            

            Button {
                viewModel.roomInvite(recieverEmail: email, message: message, roomData: roomData)
                
                fetchDeviceTokenFromEmail(email: email) { token in
                    let notifPayload: [String: Any] = [ "to": token ,
                                                        "notification": [
                                                            "title":"Room Join Request",
                                                            "body":"\(viewModel.currentUser?.fullname ?? "") invited you to join \(roomData.title)",
                                                            "sound":"default" ]
                                                      ]
                    
                    sendPushNotification(payloadDict: notifPayload)
                }
                
                presentationMode.wrappedValue.dismiss()
                
                let banner = NotificationBanner(title: "Invitation Sent", style: .success)
                banner.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    banner.dismiss()
                }
            } label: {
                Text("Send Invite").buttonStyle()
            }
            .disabled(isValidEmail(email)==false)
            .buttonStyle(.plain)

        }.navigationBarTitleDisplayMode(.inline)
        
    }
}

//
//struct RoomInviteView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomInviteView(roomData: .constant(Room(title: "Avent Ferry", newItems: [], members: []))).environmentObject(AuthViewModel())
//    }
//}
