//
//  GroupMemberInfoView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/27/22.
//

import SwiftUI

struct GroupMemberInfoView: View {
    @State var userID: String
    @State var profilePictureLink = backupPhoto
    @State var avatar = "ketchup"
    @State var name = "Default Name"
    @State var email = "Default Mail"

    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {

            ZStack(alignment: .topTrailing) {
     
                VStack(alignment: .leading) {
                    HStack {
                        VStack{
                            Image(avatar).resizable()
                                .aspectRatio(contentMode: .fill)
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
                        }.onAppear(perform: {
                            viewModel.getProfileAvatar(userID: userID) { res in self.avatar = res }
                            viewModel.getProfileName(userID: userID) { res in self.name = res }
                            viewModel.getProfileEmail(userID: userID) { res in self.email = res }
                        })
                    }

                    
                    Spacer()
                }
                .padding()
            }
        
    }
}

