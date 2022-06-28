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
                                Image(systemName: "square.and.arrow.up.fill")
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
                                print("Envelope")
                            } label: {
                                HStack {
                                    Image(systemName: "envelope.arrow.triangle.branch.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    
                                    Text("Going Shopping: Notify").padding()
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
                    
                    HStack{
                    Button(action: {
                        wantToSignOut.toggle()
                    }, label: {
                        Image(systemName: "x.square.fill").resizable().resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        
                        Text("Sign Out").padding()
                    }).buttonStyle(.plain)
                    .confirmationDialog("Are you sure?",
                      isPresented: $wantToSignOut) {
                      Button("Sign Out", role: .destructive) {
                          viewModel.signOut()
                      }
                    } message: {
                      Text("Sad to see you leave.")
                    }
                        Spacer()
                    }.padding(.bottom, 25)
                    
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
        SideMenuView(isShowing: .constant(true), roomData: .constant(Room(id: "asd", title: "Avnt Ferry", newItems: [], members: [])))    }
}
