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
                                                                                      "body":"\(userName ?? "") wants a quick chat.",
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
                } label: {
                    Image(systemName: "hand.wave.fill")
                }
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
