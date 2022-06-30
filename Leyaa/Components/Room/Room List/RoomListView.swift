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
    @State var wantToSignOut: Bool = false
    
    var body: some View {
        
        
        ZStack {
            NavigationView {
                ScrollView {
                    VStack{
                        VStack{
                            ForEach($myRoom) { room in
                                NavigationLink(destination: RoomView(roomData: room, recentDeletedItems: [])) {
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
                
            }.navigationBarBackButtonHidden(true)
        }
        
    }
    
}


struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(myRoom: .constant([Room(id: "21312", title: "Avent Ferry", newItems: [Item(id: "asdasd", name: "Coffee", desc: "Bru and Nesface", qty: "200gm")], members: [""], deviceTokens: [""])]))
    }
}
