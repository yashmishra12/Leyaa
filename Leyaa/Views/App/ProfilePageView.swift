//
//  SideMenuRoomListView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/27/22.
//

import SwiftUI
import FirebaseService
import NotificationBannerSwift

struct ProfilePageView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var wantToSignOut: Bool = false
    @State private var isExpanded: Bool = false
    @State var selectedAvatar: String
    @Environment(\.presentationMode) var presentationMode
    
    
    func actionSheet() {
        guard let data = URL(string: "https://apps.apple.com/us/app/leyaa/id1633689299") else { return }
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }.first {$0.isKeyWindow}?.rootViewController?
            .present(activityVC, animated: true, completion: {
            print("Shared")
        })

    }
    
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
                        }.padding(.top, -70)
                        
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
                            
                    }.padding(.top, -15)
      
                    HStack{
                        if (isExpanded && selectedAvatar != viewModel.currentUser?.avatar) {
                            Button {
                                viewModel.updateAvatar(userID: viewModel.currentUser?.id ?? "", newAvatar: selectedAvatar)
                                
                               successNB(title: "Avatar Changed")
                                
                            } label: {
                                Text("Save").buttonStyle()
                                   
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
                            Text("Sign Out").font(.footnote)
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
                    
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            actionSheet()
                        } label: {
                            HStack{
                                Image(systemName: "square.and.arrow.up.fill")
                                    .resizable()
                                    .padding(.leading)
                            }
                        }.buttonStyle(.plain)

                    }
                  
                }
            }
            .navigationViewStyle(.stack)
            .navigationBarBackButtonHidden(true)
        }
       
        
        
        
            }
        }
        


struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView(wantToSignOut: false, selectedAvatar: "coffee").environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
