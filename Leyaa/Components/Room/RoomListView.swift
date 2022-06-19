//
//  RoomListView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import SwiftUI
import Firebase

struct RoomListView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var title: String
    
    
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
            }
            
            
        }
        .frame(height: 150)
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
        
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView( title: .constant("Title"))
            .previewLayout(.sizeThatFits)
    }
}
