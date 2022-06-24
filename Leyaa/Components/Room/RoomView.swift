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
    
    var body: some View {
       
        ScrollView {
            VStack {
                  
                
                ForEach($roomData.newItems, id: \.self) { item in
                    VStack{
                        ItemView(item: item)
                    }
                    .background(Color("MediumBlue"))
                    .onTapGesture {
                        viewModel.deleteItem(del: item.wrappedValue, roomID: roomData.id ?? "")
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
                        ItemCreateView(name: "", qty: "", desc: "", assignedTo: "", roomData: $roomData)
                    } label: {
                        Image(systemName: "plus.app.fill").resizable().frame(width: 30, height: 30).foregroundColor(.white)
                    }.padding()
                }

            }
        }.navigationTitle(Text(roomData.title)).foregroundColor(.white)
            .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                print("Envelope")
                            } label: {
                                Image(systemName: "envelope.arrow.triangle.branch.fill").resizable().foregroundColor(.white)
                            }

                        }
                    }
           
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(
            roomData: .constant(Room(id: "", title: "", newItems: [Item(id: "", name: "", desc: "", qty: "", assignedTo: "")], members: [""]))
        )
    }
}
