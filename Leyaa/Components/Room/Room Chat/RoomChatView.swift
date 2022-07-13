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
                sendPayloadPush(token: token, roomName: roomName, body: "\(userName ?? "") sent a new post.")
            }
        }
    }
    


    var body: some View {
        VStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView{
                        ForEach(messageManager.messages, id: \.id) { message in
                            MessageBubbleView(message: message, roomID: roomData.id ?? "").onLongPressGesture {
                                if message.senderID == viewModel.currentUser?.id {
                                    
                                    withAnimation(.easeInOut) {
                                        messageManager.deleteMessage(room: roomData.id ?? "", messageID: message.id)
                                    }
                                    
                                    infoSB(title: "Message Deleted")
                                }
                            }
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
        .frame(width: screenWidth)
        .onAppear {
                messageManager.updateRoomID(name: roomData.id ?? "")
                messageManager.getMessages(roomID: roomData.id ?? "")
            }
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    inviteAllForChat()
                    successSB(title: "New Post Notification Sent To All")
                    
                } label: {
                    HStack {
                        Text("Notify All").font(.caption)
                        Image(systemName: "hand.wave.fill").imageScale(.large)
                    }.padding()
                        .padding(.trailing)
                }.buttonStyle(.plain)
                
                
                
                Button {
                    messageChatInfo()
                    
                } label: {
                    Image(systemName: "questionmark.square.fill").imageScale(.large)
                }.buttonStyle(.plain)

            }

            
        }
    }
}



//struct RoomChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomChatView (roomData: .constant(Room(id: "asd", title: "Avent Ferry", newItems: [], members: [])), messageArray: [])
//    }
//}
