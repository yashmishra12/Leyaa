//
//  SideMenuRoomListView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/27/22.
//

import SwiftUI

struct SideMenuRoomListView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var viewModel: AuthViewModel
    @State var wantToSignOut: Bool = false
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        
        VStack {
            HStack {
                VStack(spacing: 4){
                    Image(viewModel.currentUser?.avatar ?? defaultAvatar).resizable().frame(width: 150, height: 150).padding(.top, 40)
                    
                    Text(viewModel.currentUser?.fullname ?? "").font(.headline).fontWeight(.bold).foregroundColor(.white)
                    Text(viewModel.currentUser?.email ?? "").font(.footnote).fontWeight(.light).foregroundColor(.white)
                    Spacer()
                    
                }
                Spacer()
            }.padding()
            
            HStack{
                VStack {

                    Button(action: {
                        wantToSignOut = true
                    }, label: {
                        Text("Sign Out").foregroundColor(.white).fontWeight(.bold)
                    }).buttonStyle(.plain)
                    .confirmationDialog("Are you sure?",
                      isPresented: $wantToSignOut) {
                      Button("Sign Out", role: .destructive) {
                          viewModel.signOut()
                      }
                    } message: {
                      Text("Sad to see you leave. Sign back in soon.")
                    }
                }
                Spacer()
            }.padding(.horizontal, 30)
                .padding(.bottom, 30)
        }.toolbar {
            ToolbarItem {
                Button {
                    isShowing.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.circle.fill").resizable() }.buttonStyle(.plain)
                }

            }
        }
        
    }


//struct SideMenuRoomListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SideMenuRoomListView(isShowing: .constant(true))
//    }
//}
