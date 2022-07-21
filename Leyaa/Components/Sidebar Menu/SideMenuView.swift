//
//  SidebarMenuView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/26/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import NotificationBannerSwift

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State  var isExpanded: Bool = false
    @State var wantToSignOut: Bool = false

    @Binding var roomData: Room
    @State private var leavingRoom: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    var db = Firestore.firestore()
   
   
    
    @Binding var show: Bool
    
   
    
    var body: some View {
        
        ZStack {

            ScrollView(showsIndicators: false){
          
                VStack(alignment: .leading) {
                    
                    
                        // CELL ITEMS
                        VStack(spacing: 2.5) {
                            
                            HStack {
                                Button {
                                    withAnimation(.easeInOut) {
                                        isShowing.toggle()
                                    }
                                    
                                } label: {
                                    HStack {
                                        Image("blankImage")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        
                                        
                                        Spacer()
                                    } .contentShape(Rectangle())
                                        .onTapGesture {
                                            withAnimation(.easeInOut) {
                                                isShowing.toggle()
                                            }
                                        }
                                }.buttonStyle(.plain)
                                
                                
                            }
                            
                            
                            // MESSAGE WALL
                            HStack {
                                NavigationLink {
                                    RoomChatView(roomData: $roomData).hideKeyboardWhenTappedAround()
                                } label: {
                                    HStack {
                                        Image(systemName: "message.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        
                                        Text("Message Wall").padding()
                                        Spacer()
                                    }
                                }.buttonStyle(.plain)
                                
                                
                            }
                            
                            
                            
                            // Bill Split
                            HStack {
                                NavigationLink {
                                    
                                    SplitBillView(roomData: $roomData, userInfo: [[""]]).hideKeyboardWhenTappedAround()
                                } label: {
                                    HStack {
                                        
                                        Image(systemName: "dollarsign.square.fill")
                                        
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        
                                        Text("Bill Split").padding()
                                    }
                                }.buttonStyle(.plain)
                                Spacer()
                            }
                            
                           
                            //Expand
                            HStack {
                                Button {
                                    withAnimation(.easeInOut) {
                                        isExpanded.toggle()
                                    }

                                } label: {
                                    HStack {
                                        if isExpanded {
                                            Image(systemName: "chevron.up.square.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                        } else {
                                            Image(systemName: "chevron.down.square.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                        }
                                        
                                        Text("Notify Friends").padding()
                                    }
                                }.buttonStyle(.plain)
                                Spacer()
                            }
                            
                            
                            if isExpanded {
                                VStack {
                                    
                                    //Shopping
                                    HStack {
                                        Button {
                                            
                                            goingForShopping(roomData: roomData, viewModel: viewModel)
                                            withAnimation(.spring()) {
                                                show.toggle()
                                            }
                                         
                                            successSB(title: "Notification Sent")
                                            
                                            
                                        } label: {
                                            HStack {
                                                Image(systemName: "cart.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Going shopping").padding()
                                            }
                                        }.buttonStyle(.plain)
                                        Spacer()
                                    }
                                    
                                    
                                    // LAUNDRY
                                    HStack {
                                        Button {
                                            goingForLaundry(roomData: roomData, viewModel: viewModel)
                                            withAnimation(.spring()) {
                                                show.toggle()
                                            }
                                           
                                            successSB(title: "Notification Sent")
                                            
                                        } label: {
                                            HStack {
                                                
                                                Image(systemName: "tshirt.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Doing Laundry").padding()
                                            }
                                        }.buttonStyle(.plain)
                                        Spacer()
                                    }
                                    
                                    // FRIDGE IS FULL
                                    HStack {
                                        Button {
                                            fridgeIsFull(roomData: roomData, viewModel: viewModel)
                                            withAnimation(.spring()) {
                                                show.toggle()
                                            }
                                            successSB(title: "Notification Sent")
                                        } label: {
                                            HStack {
                                                
                                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Fridge is Full").padding()
                                            }
                                        }.buttonStyle(.plain)
                                        Spacer()
                                    }
                                    
                                    
                                    // CLEAN HOUSE
                                    HStack {
                                        Button {
                                            cleanHouse(roomData: roomData, viewModel: viewModel)
                                            withAnimation(.spring()) {
                                                show.toggle()
                                            }
                                            successSB(title: "Notification Sent")
                                        } label: {
                                            HStack {
                                                
                                                Image(systemName: "wand.and.stars")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Clean House").padding()
                                            }
                                        }.buttonStyle(.plain)
                                        Spacer()
                                    }
                                    
                                    
                                }.padding(.leading, 20)
                            }
                           
                            
                            // Edit Room Name
                            HStack {
                                NavigationLink {
                                    
                                    RoomNameEditView(name: roomData.title, roomData: roomData, isShowingSideMenu: $isShowing)
                                        .hideKeyboardWhenTappedAround()
                                    
                                } label: {
                                    HStack {
                                        
                                        Image(systemName: "square.and.pencil")
                                        
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        
                                        Text("Edit Room Name").padding()
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
                                        RoomInviteView(roomData: $roomData).hideKeyboardWhenTappedAround()
                                    } label: {
                                        HStack {
                                            Image(systemName: "person.fill.badge.plus")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .padding(.leading, 80)
                                                .padding(.trailing, 35)
                                            
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
                    
                        ForEach(roomData.members, id: \.self) { userID in
                            GroupMemberInfoView(userID: userID)
                        }
                    }
                    
            }
            
            
                Spacer()
  
            
        }.onTapGesture {
            withAnimation(.easeInOut) {
                isShowing.toggle()
            }
        }
        
        .navigationTitle("Menu")
        
        .navigationBarTitleDisplayMode(.inline)
        
        .navigationBarBackButtonHidden(true)
        
    }
}


struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), isExpanded: true, roomData: .constant(Room(id: "asd", title: "Avent Ferry", newItems: [], members: [])), show: .constant(true)).environmentObject(AuthViewModel())
        
    }
}
