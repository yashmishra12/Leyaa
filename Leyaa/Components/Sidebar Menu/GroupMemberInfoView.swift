//
//  GroupMemberInfoView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/27/22.
//

import SwiftUI

struct GroupMemberInfoView: View {
    @State var userID: String
    @State var profilePictureLink = "https://firebasestorage.googleapis.com:443/v0/b/leyaa-7b042.appspot.com/o/profile_image%2FF1D826A4-0955-423F-8783-6693E670DF5A?alt=media&token=0dfbd1e8-228b-446f-b224-9c205681da72"
    
    @State var name = "Default Name"
    @State var email = "Default Mail"
    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        ZStack(alignment: .topTrailing) {
 
            
            VStack(alignment: .leading) {
               
                HStack {
                    VStack{
                        AsyncImage(url: URL(string: profilePictureLink )!) {
                            Image(systemName: "person")
                        } image: { image in
                            Image(uiImage: image).resizable()
                            
                        }.aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(width: 50, height: 50).clipShape(Circle())
                    }
                    VStack{
                        HStack {
                            Text(name).font(.system(size: 24, weight: .semibold))
                            Spacer()
                        }
                        
                        HStack {
                            Text(email ).font(.system(size: 14))
                            Spacer()
                        }
                    }
                }

                
                Spacer()
            }.onAppear(perform: {
                viewModel.getProfilePicLink(userID: userID) { res in self.profilePictureLink = res }
                viewModel.getProfileName(userID: userID) { res in self.name = res }
                viewModel.getProfileEmail(userID: userID) { res in self.email = res }
            })
            .padding()
        }
    }
}

