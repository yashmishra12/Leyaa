//
//  RoomInviteView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/25/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import NotificationBannerSwift




struct RoomInviteView: View {
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var message = ""
    @State private var fullname = ""
    @Environment (\.presentationMode) var presentationMode
    
    @FocusState private var emailFocus: Bool
    @FocusState private var messageFocus: Bool
    
    func invitationSent() {
        if email.isEmpty==false {
            
            messageFocus = false
            viewModel.roomInvite(recieverEmail: email, message: message, roomData: roomData)

            fetchDeviceTokenFromEmail(email: email) { token in
                roomJoinRequestPayload (token: token, body: "\(viewModel.currentUser?.fullname ?? "") invited you to join \(roomData.title)")
            }
            
            presentationMode.wrappedValue.dismiss()
            successSB(title: "Invitation Sent")
        }
        
        else {
            emailFocus = true
        }
    }
    
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
            
            Button {
                actionSheet()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up").imageScale(.small)
                    Text("Share App").font(.footnote)
                    
                }
            }.buttonStyleBlue()
            .buttonStyle(.plain)
            
            VStack (spacing: 20) {
                CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                    .focused($emailFocus)
                    .keyboardType(.emailAddress)
                    .onSubmit {
                        messageFocus = true
                    }
                    .submitLabel(.next)

                
                CustomInputField(imageName: "message.fill", placeholderText: "Message (Optional)", text: $message)
                    .focused($messageFocus)
                    .onSubmit {
                        invitationSent()
                    }
                    .submitLabel(.send)
                
                
            }.padding()
            

            Button {
                invitationSent()
                
            } label: {
                Text("Send Invite").buttonStyleBlue()
            }
            .disabled(isValidEmail(email)==false)
            .buttonStyle(.plain)
            .padding(.bottom)
            
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                self.emailFocus = true
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        
    }
}


