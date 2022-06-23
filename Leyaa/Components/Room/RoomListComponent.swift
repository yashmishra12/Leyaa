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
                    Text(title).font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    Spacer()
                }
                Spacer()
                
                HStack{
                    if(newItems.count>5) {
                            
                        Image(newItems[0].name).resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60, alignment: .leading)
                        
                        Image(newItems[1].name).resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .leading)
                        
                        Image(newItems[2].name).resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .leading)
                        
                        Image(newItems[3].name).resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .leading)
                        
                        Image(newItems[4].name).resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .leading)

                        Image(systemName: "ellipsis").resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .leading)
                        
                    } else {
                        ForEach(newItems, id: \.self) { item in
                            Image(item.name).resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60, alignment: .leading)
                        }
                    }
                    Spacer()
                }
                
                
            }
            
            
        }
        .frame(height: 150)
        .padding(.horizontal, 2)
        .padding(.vertical, 2)
        
    }
}

struct RoomListComponent_Previews: PreviewProvider {
    static var previews: some View {
        RoomListComponent( title: .constant("Title"), newItems: .constant([]))
            .previewLayout(.sizeThatFits)
    }
}
