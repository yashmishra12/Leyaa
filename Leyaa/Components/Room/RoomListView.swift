//
//  RoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI

struct RoomListView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var myRoom: [Room]
    
    var body: some View {

        ScrollView{
            VStack{
                ForEach($myRoom) { room in
                    NavigationLink(destination: RoomView(roomData: room)) {
                        RoomListComponent(title: room.title, newItems: room.newItems).background(Color("MediumBlue"))
                    }
                }
                
                
                Spacer()
                
    
                    NavigationLink {
                        RoomCreateView(roomName: "")
                    } label: {
                        Text("Create Room")
                    }.padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(Color("MediumBlue"))
                        .clipShape(Capsule())

            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Logout").foregroundColor(.white)
                }
            }
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(myRoom: .constant([Room(id: "", title: "", newItems: [Item(name: "", desc: "", qty: "", assignedTo: "")], members: [""])]))
    }
}
