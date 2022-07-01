//
//  SidebarMenuView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/26/22.
//

import SwiftUI
import Firebase
import FirebaseService
import FirebaseFirestoreSwift


struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var roomData: Room
    @State private var leavingRoom: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State var wantToSignOut: Bool = false
    var db = Firestore.firestore()
    
   
   
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
    
    func goingForShopping() {
        let userName = viewModel.currentUser?.fullname
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            fetchDeviceToken(withUid: member) { token in
                let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                      "body":"\(userName ?? "") is going for shopping.",
                                                                                      "sound":"default"]]
                sendPushNotification(payloadDict: notifPayload)
            }
        }
    }
    
    func goingForLaundry() {
        let userName = viewModel.currentUser?.fullname
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            fetchDeviceToken(withUid: member) { token in
                let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                      "body":"\(userName ?? "") is going for laundry.",
                                                                                      "sound":"default"]]
                sendPushNotification(payloadDict: notifPayload)
            }
        }
    }
    
    func fridgeIsFull() {
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            
            fetchDeviceToken(withUid: member) { token in
                let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                      "body":"Fridge is full. Please look into it.",
                                                                                      "sound":"default"]]
                sendPushNotification(payloadDict: notifPayload)
            }
        }

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
    
    
    func cleanHouse() {
        let userName = viewModel.currentUser?.fullname
        let roomName = roomData.title
        
        for member in roomData.members where member != viewModel.currentUser?.id {
            
            
            fetchDeviceToken(withUid: member) { token in
                let notifPayload: [String: Any] = ["to": token ,"notification": ["title":"Room: \(roomName)",
                                                                                      "body":"\(userName ?? "") feels it's time to clean the house.",
                                                                                      "sound":"default"]]
                sendPushNotification(payloadDict: notifPayload)
            }
        }
        
        
    }

    
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
       
        
            
                VStack {
                    // CELL ITEMS
                    VStack(spacing: 2.5) {
                        
                        //Shopping
                        HStack {
                            Button {
                                goingForShopping()
                                withAnimation(.easeIn) {
                                    show.toggle()
                                }
                                } label: {
                                    HStack {
                                        Image(systemName: "cart.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        
                                        Text("Going shopping").padding()
                                    }
                            }.buttonStyle(.plain)
                            Spacer()
                        }

                        
                        // LAUNDRY
                        HStack {
                            Button {
                                goingForLaundry()
                                withAnimation(.easeIn) {
                                    show.toggle()
                                }
                            } label: {
                                HStack {
                                    
                                    Image(systemName: "tshirt.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                    
                                    Text("Going Laundry").padding()
                                }
                            }.buttonStyle(.plain)
                            Spacer()
                        }
                        
                        // FRIDGE IS FULL
                        HStack {
                            Button {
                                fridgeIsFull()
                                withAnimation(.easeIn) {
                                    show.toggle()
                                }
                            } label: {
                                HStack {
                                    
                                    Image("fridge")
                                        .resizable()
                                        .frame(width: 20, height: 25)
                                        .foregroundColor(.white)
                                    
                                    Text("Fridge is Full").padding()
                                }
                            }.buttonStyle(.plain)
                            Spacer()
                        }
                        
                        
                        // CLEAN HOUSE
                        HStack {
                            Button {
                                cleanHouse()
                                withAnimation(.easeIn) {
                                    show.toggle()
                                }
                            } label: {
                                HStack {
                                    
                                    Image(systemName: "wand.and.stars")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                    
                                    Text("Clean House").padding()
                                }
                            }.buttonStyle(.plain)
                            Spacer()
                        }
                        
                        // Fresh Check
                        HStack {
                            NavigationLink {
                                FreshCheckReminder(roomName: $roomData.title)
                            } label: {
                                HStack {
                                    
                                    Image(systemName: "leaf.fill")

                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                    
                                    Text("Fresh Check").padding()
                                }
                            }.buttonStyle(.plain)
                            Spacer()
                        }
                        
                        
                        // GROUP CHAT
                        HStack {
                            NavigationLink {
                                RoomChatView(roomData: $roomData)
                                } label: {
                                    HStack {
                                        Image(systemName: "message.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        
                                        Text("Message Wall").padding()
                                    }
                            }.buttonStyle(.plain)
                            Spacer()
                        }
                        
                        
                        // LEAVE ROOM
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
                        }.padding(.bottom, 25)
                        
                        
                        // ROOM MEMBERS
                        HStack {
                            Text("Members").font(.body).fontWeight(.bold)
                            HStack {
                                NavigationLink {
                                    RoomInviteView(roomData: $roomData)
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.square.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 30)
                                        
                                    }
                                }.buttonStyle(.plain)
                                

                            }
                            VStack {
                                Divider().background(Color.white)
                                    .padding(.horizontal, -20)
                            }

                        }
                    }.padding()

                    //Room Members
                    ScrollView{
                        ForEach(roomData.members, id: \.self) { userID in
                            GroupMemberInfoView(userID: userID)
                        }
                    }

                }
                
   
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), roomData: .constant(Room(id: "asd", title: "Avent Ferry", newItems: [], members: [])), show: .constant(true)).environmentObject(AuthViewModel())
        
    }
}
