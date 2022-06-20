//
//  RoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI

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
                
                ForEach(roomData.newItems, id: \.self) { item in
                    VStack{
                        HStack{
                            Image(item.name).resizable().frame(width: 100, height: 100, alignment: .leading)
                                .shadow(color: .black, radius: 2, x: 0, y: 0)
                            
                            Text(item.name).font(.title)
                            Spacer()
                            VStack{
                                Text("Qty: \(item.qty)").font(.title3)
                            }.padding(.horizontal, 15)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text(item.desc)
                                .font(.callout)
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                        }
                        
                        
                    }
                    .background(Color("MediumBlue"))
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
