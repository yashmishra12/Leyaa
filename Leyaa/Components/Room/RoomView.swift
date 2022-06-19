//
//  RoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI

struct RoomView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var prv: PopulateRoomView
    @State var myRoom: [Room] = []
    
    var body: some View {

        VStack{
            Button {
                viewModel.signOut()
            } label: {
                Text("Logout")
            }.foregroundColor(.green)
            
            Button {
                viewModel.populateRoomList()
                myRoom = viewModel.rooms
                
            } label: {
                Text("Populate")
            }.foregroundColor(.red)
            
            ForEach($myRoom) { room in
                RoomListView(title: room.title)
            }
        }.onAppear {
            viewModel.populateRoomList()
            myRoom = viewModel.rooms
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView()
    }
}
