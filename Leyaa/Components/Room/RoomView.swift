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
                
              
                
                VStack{
                    Spacer()
                    NavigationLink {
                        ItemSearchView()
                    } label: {
                        Text("Search Item")
                            .foregroundColor(.white)
                            
                    }.background()
                    
                    NavigationLink {
                        
                        ItemCreateView(name: "", qty: "", desc: "", assignedTo: "",
                                       roomData: $roomData)
                        
                    } label: {
                        Text("Add Item").foregroundColor(.white)
                    }
                }

            }
        }.navigationTitle(Text(roomData.title)).foregroundColor(.white).multilineTextAlignment(.leading)
           
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(
            roomData: .constant(Room(id: "", title: "", newItems: [Item(id: "", name: "", desc: "", qty: "", assignedTo: "")], members: [""]))
        )
    }
}
