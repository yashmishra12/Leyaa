//
//  RoomListView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import SwiftUI
import Firebase
 
struct RoomListComponent: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var title: String
    @Binding var newItems: [Item]
    private let itemShowCount  = 5
    
   
    
    var body: some View {
        ZStack {

            
            VStack(alignment: .leading) {
               
                VStack{
                    
                     HStack {
                         Text(title.capitalized).font(.title)
                             .fontWeight(.bold)
                             .foregroundColor(Color.white)
                             .multilineTextAlignment(.leading)
                         Spacer()
                     }.padding(.horizontal)
                }.padding()
                
                Spacer()
               
                VStack{
                    HStack{
                        if(newItems.count>itemShowCount) {
                                
                            ForEach( (0..<itemShowCount), id: \.self) {
                                Image(newItems[$0].name.sanitiseItemName()).resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60, alignment: .leading)
                                Spacer()
                            }


                            Image(systemName: "ellipsis").resizable().foregroundColor(.white)
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .leading)
                            
                        }
                        else {
                            ForEach(newItems, id: \.self) { item in
                                Image(item.name.sanitiseItemName()).resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60, alignment: .leading)
                            }
                        }
                        Spacer()
                    }
                }.padding()
                
                
            }
            
            
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
        
    }
}

struct RoomListComponent_Previews: PreviewProvider {
    static var previews: some View {
        RoomListComponent( title: .constant("Avent Ferry"), newItems: .constant([Item(id: "213123asd", name: "Coffee", desc: "Coffee is nice", qty: "200gm")]))
            .previewLayout(.sizeThatFits)
    }
}
