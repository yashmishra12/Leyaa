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
                                Label("Room Requset", systemImage: "bell.square.fill")
                            }
                            .badge(viewModel.pendingReqest.count > 0 ? "\(viewModel.pendingReqest.count)" : nil)
                            

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
    
//    extension ContentView {
//
//
//        var mainInterfaceView: some View {
//            ZStack(alignment: .topLeading) {
//
//
//
//                if showMenu {
//                    ZStack {
//                        Color(.black)
//                            .opacity(showMenu ? 0.25 : 0.0)
//                    }.onTapGesture {
//                        withAnimation(.easeInOut) {
//                            showMenu = false
//                        }
//                    }
//                    .ignoresSafeArea()
//                }
//
//            }
//            .navigationTitle("Home")
//            .navigationBarTitleDisplayMode(.inline)
//
//            .onAppear {
//                showMenu = false
//            }
//
//
//
//        }
//    }
