//
//  RoomChatView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/28/22.
//

import SwiftUI
import Firebase
import FirebaseService
import FirebaseFirestoreSwift
import NotificationBannerSwift

struct RoomChatView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @Binding var roomData: Room
    @StateObject var messageManager = MessageManager()
    var db = Firestore.firestore()

    
    func inviteAllForChat() {

        let userName = viewModel.currentUser?.fullname
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            fetchDeviceToken(withUid: member) { token in
                let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                      "body":"\(userName ?? "") posted a new message.",
                                                                                      "sound":"default"]]
                sendPushNotification(payloadDict: notifPayload)
            }
        }
    }
    


    var body: some View {
        VStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView{
                        ForEach(messageManager.messages, id: \.id) { message in
                            MessageBubbleView(message: message)
                        }
                    }
                    .onChange(of: messageManager.lastMessageID) { id in
                        withAnimation { proxy.scrollTo(id, anchor: .bottom) }
                    }
                    .onAppear(perform: {
                        proxy.scrollTo(messageManager.lastMessageID, anchor: .bottom)
                    })
                    
                    .frame(width: screenWidth)


                }
            }.frame(width: screenWidth)

            MessageField(senderID: viewModel.currentUser?.id ?? "", roomData: $roomData)
                .environmentObject(messageManager)

        }
        .navigationTitle(roomData.title)
        .toolbar(content: {
            ToolbarItem {
                Button {
                    inviteAllForChat()
                    let banner = StatusBarNotificationBanner(title: "Notification Sent", style: .success)
                    banner.show()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        banner.dismiss()
                    }
                    
                } label: {
                    Image(systemName: "hand.wave.fill").imageScale(.large)
                }.buttonStyle(.plain)
            }
        })
        .frame(width: screenWidth)
        .onAppear {
                messageManager.updateRoomID(name: roomData.id ?? "")
                messageManager.getMessages(roomID: roomData.id ?? "")
            }
    }
}



//struct RoomChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomChatView (roomData: .constant(Room(id: "asd", title: "Avent Ferry", newItems: [], members: [])), messageArray: [])
//    }
//}
