//
//  SidebarMenuView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/26/22.
//

import SwiftUI

struct SidebarMenuView: View {
    var body: some View {
            
            VStack {
                Text("Settings").font(.title2).foregroundColor(.white)
                Spacer()
                
            }.padding(16)
            .background(Color.black)
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct SidebarMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarMenuView()
    }
}
