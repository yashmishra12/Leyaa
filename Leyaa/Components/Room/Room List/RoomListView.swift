//
//  RoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI

struct RoomListView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State var isShowingMenuBar: Bool = false
    @Binding var myRoom: [Room]
    
    var body: some View {
        
        ZStack{
            if isShowingMenuBar {
                SideMenuRoomListView(isShowing: $isShowingMenuBar)
            }
        
        
        ZStack {
            NavigationView {
                ScrollView {
                    VStack{
                        VStack{
                            ForEach($myRoom) { room in
                                NavigationLink(destination: RoomView(roomData: room)) {
                                    RoomListComponent(title: room.title, newItems: room.newItems).background(Color("MediumBlue"))
                                }.buttonStyle(.plain)
                            }
                            
                            
                            Spacer()
                            
                            
                            VStack {
                                NavigationLink {
                                    RoomCreateView()
                                } label: {
                                    Text("Create Room")
                                }.padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .foregroundColor(.white)
                                    .background(Color("MediumBlue"))
                                    .clipShape(Capsule())
                                    .buttonStyle(.plain)
                            }.padding(.vertical, 35)
                            
                        }
                    }
                    
                    
                }
                .navigationTitle("Rooms")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(.spring()) {
                            isShowingMenuBar.toggle()
                        }
                        
                    }
                    label: { Image(systemName: "line.3.horizontal.circle.fill").resizable() }.buttonStyle(.plain)
                    }

                }
                
            }.navigationBarBackButtonHidden(isShowingMenuBar ? false : true)
        }
            .cornerRadius(isShowingMenuBar ? 20 : 0)
            .offset(x: isShowingMenuBar ? screenWidth*0.5 : 0, y: isShowingMenuBar ? screenHeight*0.05 : 0)
            .scaleEffect(isShowingMenuBar ? 0.8 : 1)
        }
        .onAppear {
            isShowingMenuBar = false
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(myRoom: .constant([Room(id: "21312", title: "Avent Ferry", newItems: [Item(id: "asdasd", name: "Coffee", desc: "Bru and Nesface", qty: "200gm")], members: [""])]))
    }
}
