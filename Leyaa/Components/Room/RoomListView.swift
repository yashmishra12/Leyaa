//
//  RoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI


var room2 = Room(id: "id", title: "title", newIetms: [""], oldItems: [""], members: [""])



struct RoomListView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var myRoom: [Room]
    
    var body: some View {

        ScrollView{
            VStack{
                ForEach($myRoom) { room in
                    NavigationLink(destination: RoomView()) {
                        RoomListComponent(title: room.title, newItems: room.newIetms)
                    }
                }
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Logout")
                }
            }
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(myRoom: .constant([Room(id: "", title: "", newIetms: [""], oldItems: [""], members: [""])]))
    }
}
