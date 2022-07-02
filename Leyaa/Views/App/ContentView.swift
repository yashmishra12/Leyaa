//
//  ContentView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
            ZStack(alignment: .topLeading) {
                Group {
                    if viewModel.userSession == nil {
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
                .onChange(of: scenePhase) { newPhase in
                                if newPhase == .active {
                                    print("Active")
                                } else if newPhase == .inactive {
                                    UIApplication.shared.applicationIconBadgeNumber = 0
                                    UserDefaults.standard.set(0, forKey: "com.yashmisra12.Leyaa.badgeCount")
                                } else if newPhase == .background {
                                    UIApplication.shared.applicationIconBadgeNumber = 0
                                    UserDefaults.standard.set(0, forKey: "com.yashmisra12.Leyaa.badgeCount")
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
    
