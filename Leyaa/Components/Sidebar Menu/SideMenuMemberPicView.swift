//
//  SideMenuMemberPicView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/27/22.
//

import SwiftUI

struct SideMenuMemberPicView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var userID: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
//            let name = viewModel.getProfilePicLink(userID: userID)
            let name = viewModel.currentUser?.fullname
            let profilePictureLink = viewModel.currentUser?.profileImageUrl
            let email = viewModel.currentUser?.email
            
            VStack(alignment: .leading) {
               
                HStack {
                    VStack{
                        AsyncImage(url: URL(string: profilePictureLink ?? "")!) {
                            Image(systemName: "person")
                        } image: { image in
                            Image(uiImage: image).resizable()
                            
                        }.aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(width: 64, height: 64).clipShape(Circle())
                            .padding(.bottom, 16)
                    }
                    VStack{
                        HStack {
                            Text(name  ?? "").font(.system(size: 24, weight: .semibold))
                            Spacer()
                        }
                        
                        
                        HStack {
                            Text(email ?? "").font(.system(size: 14))
                            Spacer()
                        }
                    }
                }

                
                Spacer()
            }
            .padding()
        }
    }
}

//struct SideMenuMemberPicView_Previews: PreviewProvider {
//    static var previews: some View {
//        SideMenuMemberPicView(userID: "random")
//    }
//}
