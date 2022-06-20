//
//  ContentView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Group {
                if viewModel.userSession == nil {
                    LoginView()
                } else {
                    RoomListView(myRoom: $viewModel.rooms)
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

extension ContentView {
    
    
    var mainInterfaceView: some View {
        ZStack(alignment: .topLeading) {
           
            
            
            if showMenu {
                ZStack {
                    Color(.black)
                        .opacity(showMenu ? 0.25 : 0.0)
                }.onTapGesture {
                    withAnimation(.easeInOut) {
                        showMenu = false
                    }
                }
                .ignoresSafeArea()
            }
            
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                if let user = viewModel.currentUser {
//                    Button {
//                        withAnimation(.easeInOut) {
//                            showMenu.toggle()
//                        }
//                    } label: {
//                        KFImage(URL(string: user.profileImageUrl))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 32, height: 32)
//                            .clipShape(Circle())
//                    }
//                }
//
//            }
//        }
        .onAppear {
            showMenu = false
        }
        
        

    }
}
