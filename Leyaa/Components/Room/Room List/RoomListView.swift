//
//  RoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI
import AuthenticationServices

struct RoomListView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State var isShowingMenuBar: Bool = false
    @Binding var myRoom: [Room]
    @State var wantToSignOut: Bool = false
    

    var body: some View {
       
        
        ZStack {
           
            NavigationView {
                
                ScrollView {
                    
                    if myRoom.count>0 {
                        
                        VStack{
                            VStack{
                                ForEach($myRoom) { room in
                                    NavigationLink(destination: RoomView(roomData: room, recentDeletedItems: [])) {
                                        RoomListComponent(title: room.title, newItems: room.newItems).background(Color("MediumBlue"))
                                    }.buttonStyle(.plain)
                                }
                                
                                
                                Spacer()
                                
                       
                            }
                        }
                     }
                    else {
                        
                        Image("noRoom").resizable().aspectRatio(contentMode: .fit)
                    }
                }
                
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        NavigationLink {
                            RoomCreateView().hideKeyboardWhenTappedAround()
                        } label: {
                           
                            ZStack {
                                Image(systemName: "house.fill").imageScale(.large)
                                Image(systemName: "plus.circle.fill").imageScale(.small).offset(x: 16, y: 10)
                            }
                                .padding(.horizontal, 10)
                        }.buttonStyle(.plain)
                        
                    }
                })
                    .navigationTitle("Rooms")
                
            }
            .navigationViewStyle(.stack)
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
}


struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(myRoom: .constant([Room(id: "21312", title: "Avent Ferry", newItems: [Item(id: "asdasd", name: "Coffee", desc: "Bru and Nesface", qty: "200gm")], members: [""])])
        )
    }
}
