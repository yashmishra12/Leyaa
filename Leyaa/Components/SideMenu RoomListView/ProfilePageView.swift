//
//  SideMenuRoomListView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/27/22.
//

import SwiftUI

struct ProfilePageView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var wantToSignOut: Bool = false
    @State private var isExpanded: Bool = false
    @State var selectedAvatar: String
    @Environment(\.presentationMode) var presentationMode
    
    var fiveColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var threeRowGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        
        ZStack {

            VStack {

                VStack{
                    HStack {
                        Image(selectedAvatar).resizable().frame(width: 300, height: 300).padding(.top, 40).padding(.bottom, -60)
                    }.ignoresSafeArea()
                
                    VStack {
                        HStack{
                            Text(viewModel.currentUser?.fullname ?? "").font(.title).fontWeight(.bold).foregroundColor(.white)
                        }
                        HStack {
                            Text(viewModel.currentUser?.email ?? "").font(.body).fontWeight(.light).foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                }
            
                
            
                Spacer()
              
                ScrollView{
                    DisclosureGroup("Avatar", isExpanded: $isExpanded) {
                        VStack {
                            LazyVGrid(columns: fiveColumnGrid) {
                                    ForEach(assetName, id: \.self) { avatar in
                                        Image(avatar).resizable().frame(width: 50, height: 50).padding()
                                            .onTapGesture {
                                                self.selectedAvatar = avatar
                                            }
                                    }
                                
                            }
                        }
                        
                    }.font(.headline)
                }
                
                HStack{
                    if (isExpanded && selectedAvatar != viewModel.currentUser?.avatar) {
                        Button {
                                viewModel.updateAvatar(userID: (viewModel.currentUser?.id)!, newAvatar: selectedAvatar)
                        } label: {
                            Text("Save")
                        }
                    }
                
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 30)
                .padding(.top, 20)

            }
            .padding(.horizontal, 20)
            .onAppear {
                selectedAvatar = viewModel.currentUser?.avatar ?? defaultAvatar
            }
        }
        
        
        
            }
        }
        


//struct ProfilePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePageView(viewModel: .constant(AuthViewModel), wantToSignOut: false)
//    }
//}
