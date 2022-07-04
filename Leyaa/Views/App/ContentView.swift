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
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
            
        if currentPage > totalPages {
            ZStack(alignment: .topLeading) {
                Group {
                    if viewModel.userSession == nil {
                        LoginView().environmentObject(viewModel)
                    } else {
                        TabView{
                            RoomListView(myRoom: $viewModel.rooms)
                                .onAppear {
                                    viewModel.populateRoomList()
                                    viewModel.roomJoinRequestUpdate()
                                }
                               .tabItem {Label("Rooms", systemImage: "house.fill")}
                            
                            
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

                                      UIApplication.shared.applicationIconBadgeNumber = viewModel.pendingReqest.count
                                    
                                } else if newPhase == .background {

                                      UIApplication.shared.applicationIconBadgeNumber = viewModel.pendingReqest.count
                                }
                            }
            }
        }
        else {
            
            WalkThroughScreen().environmentObject(viewModel)
                .onAppear {
                viewModel.signOut()
            }
        }
    }
    
}


struct WalkThroughScreen: View {
    @AppStorage("currentPage") var currentPage = 1
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            
            if currentPage == 1{
                ScreenView(image: "relax4",
                           title: "Create Rooms",
                           detail: "Create rooms and add members in them from the sidebar.")
                .transition(.identity)
                
            }
            if currentPage == 2 {
                ScreenView(image: "relax3",
                           title: "Add Items",
                           detail: "Add items, edit them by sliding right, and long press to delete").transition(.identity)
            }

            
            if currentPage == 3 {
                ScreenView(image: "relax2",
                           title: "Tell your Friends",
                           detail: "Tell them when you go shopping so they can add items.").transition(.identity)
            }
            
            if currentPage == 4 {
                
                ScreenView(image: "relax1",
                           title: "Notify your Friends",
                           detail: "Message them on the Message Wall and hit the 👋 icon to notify them.").transition(.identity)
            }
    
            
        
            
        }.overlay( Button (action: {
            withAnimation(.easeInOut) {
                    currentPage += 1
    
            }
        }, label: {
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    ZStack {
                    Circle().stroke(Color.blue.opacity(0.05), lineWidth: 5)
                    
                    Circle().trim(from: 0, to: CGFloat(currentPage)/CGFloat(totalPages)).stroke(Color.blue, lineWidth: 5)
                            .rotationEffect(.init(degrees: -90))
                            }.padding(-15)
                )
        }).buttonStyle(.plain)
            .padding(.bottom, 20)
                   , alignment: .bottom
        )
    }
}

struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().environmentObject(AuthViewModel())
        }
    }
    

struct ScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    @AppStorage("currentPage") var currentPage = 1
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {

                if currentPage != 1 {
                    Button {
                        withAnimation (.easeInOut){
                            currentPage -= 1;
                        }
                    } label: {
                        Image(systemName: "chevron.left").foregroundColor(.white).padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.blue.opacity(0.5))
                            .cornerRadius(10)
                    }.buttonStyle(.plain)

                }
                Spacer()
                
                Button {
                    withAnimation (.easeInOut) {
                        currentPage = 10
                    }
                } label: {
                    Text("Skip").fontWeight(.semibold)
                }.buttonStyle(.plain)
                
            }
            .padding()
            
            Spacer(minLength: 0)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Text(detail)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            
            
            Spacer(minLength: 120)
        }
    }
}

var totalPages = 4
