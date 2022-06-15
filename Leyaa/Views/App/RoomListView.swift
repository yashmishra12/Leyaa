//
//  RoomListView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import SwiftUI

struct RoomListView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color("DarkBlue").ignoresSafeArea()
            
            VStack {
                Image(systemName: "envelope.fill").foregroundColor(.white)
                
                
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Log Out")
                }.foregroundColor(Color(.green)).padding(30)
            }
            
            
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView()
    }
}
