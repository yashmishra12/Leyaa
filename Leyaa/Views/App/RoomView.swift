//
//  RoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct RoomView: View {
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var leavingRoom: Bool = false

    
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {

        ScrollView {
            VStack  {
                  
              
                LazyVGrid(columns: twoColumnGrid, alignment: .leading) {
                    ForEach($roomData.newItems) { item in
                        VStack{
                            ItemView(item: item, roomData: $roomData)
                        }
                       
                    }
                }
 
                
                HStack{
           
                    NavigationLink {
                        ItemSearchView()
                    } label: {
                        Image(systemName: "sparkle.magnifyingglass").resizable().frame(width: 30, height: 30).foregroundColor(.white)
                    }.padding()
                    
                    Spacer()
                    
                    NavigationLink {
                        ItemCreateView(name: "", qty: "", desc: "",roomData: $roomData)
                    } label: {
                        Image(systemName: "plus.app.fill").resizable().frame(width: 30, height: 30).foregroundColor(.white)
                    }.padding()
                }

            }
        }.navigationTitle(Text(roomData.title)).foregroundColor(.white)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        RoomInviteView(roomData: $roomData)
                    } label: {
                        Image(systemName: "square.and.arrow.up.fill").resizable().foregroundColor(.white)
                    }

                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Envelope")
                    } label: {
                        Image(systemName: "envelope.arrow.triangle.branch.fill").resizable().foregroundColor(.white)
                    }

                }
                        ToolbarItem(placement: .navigationBarTrailing) {

                            Button(action: {
                                leavingRoom = true
                            }, label: {
                                Image(systemName: "x.square.fill").resizable().foregroundColor(.white)
                            })
                            .confirmationDialog("Are you sure?",
                              isPresented: $leavingRoom) {
                              Button("Leave Room", role: .destructive) {
                                  viewModel.leaveRoom(roomData: roomData)
                                  
                              }
                            } message: {
                              Text("One of the group members will have to add you back")
                            }

                        }
                    }
           
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(
            roomData: .constant(Room(id: "2dsasdasd", title: "Avent Ferry", newItems: [Item(id: "22020", name: "Coffee", desc: "Coffee is nice", qty: "200gm")], members: ["asdas", "bbasdasd"]))
        )
    }
}
