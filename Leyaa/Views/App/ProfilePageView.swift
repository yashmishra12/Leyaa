//
//  SideMenuRoomListView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/27/22.
//

import SwiftUI
import Combine
import FirebaseService

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
            NavigationView {
                VStack {

                    VStack{
                        HStack {
                            Image(selectedAvatar).resizable().frame(width: 300, height: 300).padding(.top, 40).padding(.bottom, -60)
                        }.ignoresSafeArea()
                    
                        VStack {
                            HStack{
                                Text(viewModel.currentUser?.fullname ?? "").font(.title).fontWeight(.bold)
                            }
                            HStack {
                                Text(viewModel.currentUser?.email ?? "").font(.caption).fontWeight(.light)
                            }
                        }.padding(.top, -90)
                        
                        Spacer()
                    }
                
                    

                  
                    ScrollView{
 
                        DisclosureGroup(isExpanded: $isExpanded) {
                            VStack {
                                LazyVGrid(columns: fiveColumnGrid) {
                                    ForEach(assetName, id: \.self) { avatar in
                                        let toShow = avatar.sanitiseItemName()
                                        Image(toShow).resizable().frame(width: 50, height: 50).padding()
                                                .onTapGesture {
                                                    self.selectedAvatar = toShow
                                                }
                                        }
                                    
                                }
                            }
                        } label: {
                            Text("Choose a new Avatar").font(.headline)
                        }.tint(Color.blue)
                            
                    }
      
                    HStack{
                        if (isExpanded && selectedAvatar != viewModel.currentUser?.avatar) {
                            Button {
                                viewModel.updateAvatar(userID: viewModel.currentUser?.id ?? "", newAvatar: selectedAvatar)
                            } label: {
                                Text("Save")
                                    .foregroundColor (.white)
                                    .frame (width: screenWidth * 0.25, height: 35)
                                    .background(Color("MediumBlue"))
                                    .clipShape(Capsule())
                            }.buttonStyle(.plain)
                        }
                    
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 30)
                    .padding(.top, 20)

                }
                .padding(.horizontal, 20)
                .onAppear { selectedAvatar = viewModel.currentUser?.avatar ?? defaultAvatar }
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            wantToSignOut.toggle()
                        }, label: {
                            Text("Sign Out").font(.caption2)
                        }).buttonStyle(.plain)
                        .confirmationDialog("Are you sure?",
                          isPresented: $wantToSignOut) {
                          Button("Sign Out", role: .destructive) {
                              viewModel.signOut()
                          }
                        } message: {
                          Text("Sad to see you leave.")
                        }
                    }
                }
            }.navigationBarBackButtonHidden(true)
        }
       
        
        
        
            }
        }
        


struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView(wantToSignOut: false, selectedAvatar: "coffee").environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
