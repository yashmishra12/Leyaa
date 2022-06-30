//
//  SidebarMenuView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/26/22.
//

import SwiftUI


struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var roomData: Room
    @State private var leavingRoom: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State var wantToSignOut: Bool = false
   
    @Binding var show: Bool
    
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
    
    func goingForShopping(deviceTokens: [String], roomName: String) {
        let userName = viewModel.currentUser?.fullname
        
        
        for token in deviceTokens where token != viewModel.currentUser?.deviceToken{
            let notifPayload: [String: Any] = ["to": token,"notification": ["title":"\(roomName)",
                                                                          "body":"\(userName ?? "") is going shopping.",
                                                                          "sound":"default"]]
            sendPushNotification(payloadDict: notifPayload)
            
            print(token)
        }
    }
    
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                // CELL ITEMS
                VStack(spacing: 4) {
                    
                    HStack {
                        NavigationLink {
                            RoomInviteView(roomData: $roomData)
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                
                                Text("Add Friend").padding()
                            }
                        }.buttonStyle(.plain)
                        
                        Spacer()
                    }

                    
                    HStack {
                        Button {
                            goingForShopping(deviceTokens: roomData.deviceTokens, roomName: roomData.title)
                            withAnimation(.easeIn) {
                                show.toggle()
                            }
                            } label: {
                                HStack {
                                    Image(systemName: "envelope.arrow.triangle.branch.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    
                                    Text("I'm going shopping").padding()
                                }
                        }.buttonStyle(.plain)
                        Spacer()
                    }


                    HStack {
                        NavigationLink {
                            RoomChatView(roomData: $roomData)
                            } label: {
                                HStack {
                                    Image(systemName: "message.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    
                                    Text("Group Chat").padding()
                                }
                        }.buttonStyle(.plain)
                        Spacer()
                    }
                    
                    
                    HStack{
                        Button(action: {
                            leavingRoom = true
                        }, label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right.fill").resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                
                                Text("Leave Room").padding()
                            }
                        }).buttonStyle(.plain)
                        .confirmationDialog("Are you sure?",
                            isPresented: $leavingRoom) {
                            Button("Leave Room", role: .destructive) {
                                viewModel.leaveRoom(roomData: roomData)
                            }
                        } message: {
                            Text("One of the group members will have to add you back")
                        }
                        Spacer()
                    }
                    
                    
                    
                    HStack {
                        Text("Room Members").font(.body).fontWeight(.bold)
                        VStack {
                            Divider().background(Color.white)
                        }
                        Spacer()
                    }
                }.padding()
                

                
                ScrollView{
                    ForEach(roomData.members, id: \.self) { userID in
                        GroupMemberInfoView(userID: userID)
                    }
                }

                
                Spacer()
                
            }
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), roomData: .constant(Room(id: "asd", title: "Avnt Ferry", newItems: [], members: [], deviceTokens: [""])), show: .constant(true))    }
}
