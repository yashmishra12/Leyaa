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
    
    func actionSheet() {
        guard let data = URL(string: "https://apps.apple.com/us/app/leyaa/id1633689299") else { return }
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }.first {$0.isKeyWindow}?.rootViewController?
            .present(activityVC, animated: true, completion: {
            print("Shared")
        })

    }
    
 
    var body: some View {
        VStack {
            
            Image("addMember").resizable().aspectRatio(contentMode: .fit).padding(.top, -100)
            
            VStack (spacing: 20) {
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
            .padding(.bottom)
            
            
            Button {
                actionSheet()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up").imageScale(.small)
                    Text("Share App").font(.footnote)
                    
                }
            }.buttonStyle()
            .buttonStyle(.plain)
            .padding(.top)


        }.navigationBarTitleDisplayMode(.inline)
        
    }
}


