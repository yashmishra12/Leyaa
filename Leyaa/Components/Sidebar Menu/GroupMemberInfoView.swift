//
//  GroupMemberInfoView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/27/22.
//

import SwiftUI

struct GroupMemberInfoView: View {
    @State var userID: String
    @State var avatar = "ketchup"
    @State var name = "Default Name"
    @State var email = "Default Mail"
    private let pasteBoard = UIPasteboard.general
    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {

            ZStack(alignment: .topTrailing) {
     
                VStack(alignment: .leading) {
                    HStack {
                        VStack{
                            Image(avatar).resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                        }
                        
                        VStack{
                            HStack {
                                Text(name).font(.body).fontWeight(.semibold)
                                Spacer()
                            }
                            
                            HStack {
                                Text(email).font(.caption2).onTapGesture {
                                    pasteBoard.string = email
                                    successSB(title: "Copied")
                                }
                                Button {
                                    pasteBoard.string = email
                                    successSB(title: "Copied")
                                } label: {
                                    Image(systemName: "doc.on.doc").resizable().frame(width: 12, height: 16)
                                }.buttonStyle(.plain)
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
                .padding(.bottom, 10)
            }
        
    }
}

