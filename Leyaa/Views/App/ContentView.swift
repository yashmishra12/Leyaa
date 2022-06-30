//
//  ContentView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var viewModel: AuthViewModel
    
    
    var body: some View {
            ZStack(alignment: .topLeading) {
                Group {
                    if !viewModel.didAuthenticateUser {
                        LoginView()
                    } else {
                        TabView{
                            RoomListView(myRoom: $viewModel.rooms)
                                .onAppear {
                                    viewModel.populateRoomList()
                                    viewModel.roomJoinRequestUpdate()
                                }.tabItem {Label("Rooms", systemImage: "house.fill")}
                            
                            
                            RoomJoinRequestView(roomRequest: $viewModel.pendingReqest).tabItem {
                                Label("Invitation", systemImage: "bell.square.fill")
                            }
                            .badge(viewModel.pendingReqest.count > 0 ? "\(viewModel.pendingReqest.count)" : nil)
                            
                            ProfilePageView(selectedAvatar: defaultAvatar).tabItem {
                                Label("Profile", systemImage: "person.crop.square.fill")
                            }

                        }
                        
                        
                    }
                }
            }
        
    }
    
}
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
