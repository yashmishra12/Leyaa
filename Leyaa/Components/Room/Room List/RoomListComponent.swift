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
    
    var body: some View {
        ZStack {
            Color("MediumBlue").ignoresSafeArea()
            
            VStack(alignment: .leading) {
               
               
                HStack {
                    Text(title.capitalized).font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 5)
                    
                    Spacer()
                }

                
                HStack{
                    if(newItems.count>5) {
                            
                        Image(newItems[0].name.sanitiseItemName()).resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60, alignment: .leading)
                        
                        Image(newItems[1].name.sanitiseItemName()).resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .leading)
                        
                        Image(newItems[2].name.sanitiseItemName()).resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .leading)
                        
                        Image(newItems[3].name.sanitiseItemName()).resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .leading)
                        
                        Image(newItems[4].name.sanitiseItemName()).resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .leading)

                        Image(systemName: "ellipsis").resizable()
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
                
                
            }
            
            
        }
        .frame(height: 100)
        .padding(.horizontal, 1)
        .padding(.vertical, 1)
        
    }
}

struct RoomListComponent_Previews: PreviewProvider {
    static var previews: some View {
        RoomListComponent( title: .constant("Avent Ferry"), newItems: .constant([Item(id: "213123asd", name: "Coffee", desc: "Coffee is nice", qty: "200gm")]))
            .previewLayout(.sizeThatFits)
    }
}