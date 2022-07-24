//
//  ProfilePageView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/16/22.
//

import SwiftUI
import NotificationBannerSwift


struct ProfilePageView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var wantToSignOut: Bool = false
    @State var aboutPage: Bool = false
    @State var startWantToDeactivate: Bool = false
    @State var wantToDeactivate: Bool = false
    @State private var isExpanded: Bool = false
    @State var selectedAvatar: String
    
    
    private let pasteBoard = UIPasteboard.general
    
    
    func actionSheet() {
        guard let data = URL(string: "https://apps.apple.com/us/app/leyaa/id1633689299") else { return }
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }.first {$0.isKeyWindow}?.rootViewController?
            .present(activityVC, animated: true, completion: {
                print("Shared")
            })
        
    }
    
    
    var body: some View {
        
        ZStack {
            
            NavigationView {
                
                VStack {
                    
                    VStack (spacing: 2){
                        HStack {
                            ZStack {
                                NavigationLink(destination: AboutView(),
                                               isActive: $aboutPage,
                                               label: { }).buttonStyle(.plain)
                                
                                NavigationLink(destination: DeleteAccount_Step1(),
                                               isActive: $startWantToDeactivate,
                                               label: { }).buttonStyle(.plain)
                                
                                Image(selectedAvatar).resizable().frame(width: 300, height: 300).padding(.top, 40).padding(.bottom, -60)
                            }
                        }.ignoresSafeArea()
                        
                        VStack (spacing: 1) {
                            HStack{
                                
                                NavigationLink  {
                                    NameChangeView()
                                } label: {
                                    HStack {
                                        Text(viewModel.currentUser?.fullname ?? "").font(.title).fontWeight(.bold).padding(.trailing)
                                        Image(systemName: "pencil").resizable().frame(width: 12, height: 12)
                                    }
                                }.padding(.leading, 10)
                                    .buttonStyle(.plain)
                            }
                            HStack {
                                
                                Button {
                                    pasteBoard.string = viewModel.currentUser?.email ?? ""
                                    successSB(title: "Copied")
                                } label: {
                                    HStack {
                                        Text(viewModel.currentUser?.email ?? "").font(.caption).fontWeight(.light).padding(.trailing)
                                        Image(systemName: "doc.on.doc").resizable().frame(width: 12, height: 15)
                                    }
                                    
                                }.buttonStyle(.plain)
                                    .padding(.leading, 10)
                                
                            }.padding(.bottom)
                        }.padding(.top, -70)
                        
                        Spacer()
                    }
                    
                    
                    
                    
                    ScrollView (showsIndicators: false) {
                        
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
                                
                                successSB(title: "Avatar Changed")
                                
                            } label: {
                                Text("Save").buttonStyleBlue()
                                
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
                        
                        Menu {
                            Button {
                                aboutPage.toggle()
                            } label: {
                                Text("About").font(.footnote)
                            }.buttonStyle(.plain)

                            
                            Button {
                                wantToSignOut.toggle()
                            } label: {
                                Text("Sign Out").font(.footnote)
                            }.buttonStyle(.plain)
                            
                            
                            Button {
                                wantToDeactivate.toggle()
                            } label: {
                                Text("Delete Account").font(.footnote)
                            }.buttonStyle(.plain)
                        }
                        
                    label: {
                        Image(systemName: "gear").resizable()
                    }
                    .confirmationDialog("Are you sure?",
                                        isPresented: $wantToSignOut) {
                        Button("Sign Out", role: .destructive) {
                            viewModel.signOut()
                        }
                    } message: {
                        Text("Sad to see you leave.")
                    }
                        
                    .confirmationDialog("Are you sure?",
                                        isPresented: $wantToDeactivate) {
                        
                        Button("Start Account Delete", role: .destructive) {
                            startWantToDeactivate.toggle()
                        }
                    } message: {
                        Text("This will initiate permanent account deletion process.")
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
