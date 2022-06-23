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
                  
                HStack{
                    Text(roomData.title).font(.largeTitle).foregroundColor(.white).multilineTextAlignment(.leading)
                    
                    Spacer()
                    }
                
                ForEach($roomData.newItems, id: \.self) { item in
                    VStack{
                        ItemView(item: item)
                    }
                    .background(Color("MediumBlue"))
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
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(
            roomData: .constant(Room(id: "", title: "", newItems: [Item(name: "", desc: "", qty: "", assignedTo: "")], members: [""]))
        )
    }
}
