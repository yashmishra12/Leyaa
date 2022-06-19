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
                        RoomListComponent(title: room.title, newItems: room.newIetms)
                    }
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
                }
                .padding(.vertical, 40)
                
                

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
            .preferredColorScheme(.dark)
    }
}
