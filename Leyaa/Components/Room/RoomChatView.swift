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
    
    func sendPushNotification(payloadDict: [String: Any]) {
        let serverKey: String = "AAAAWl5yGoA:APA91bF3eAohb9tcD5tk1a4sxjwJvk8kn0N0b6ETi-ShuUod73bmM2uWOlSQgLn9x-4kUJTtJ9kDvYdwzM42Ehxuw12aGXUmjF8zAsNez13eidYvItMN23afUvbrC0JIpXacJndMc7kw"
       let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
       var request = URLRequest(url: url)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
       request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payloadDict, options: [.prettyPrinted])
       let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data, error == nil else {
            print(error ?? "")
            return
          }
          if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print(response ?? "")
          }
          print("Notfication sent successfully.")
          let responseString = String(data: data, encoding: .utf8)
          print(responseString ?? "")
       }
       task.resume()
    }
    
    func fetchDeviceToken(withUid uid: String, completion: @escaping(String) -> Void) {
        Firestore.firestore().collection("users").document(uid)
            .getDocument { document, error in
                if let document = document, document.exists {
                    let property = document.get("deviceToken") as! String
                    completion(property)
                }
            }
    }
    
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
