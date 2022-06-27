//
//  RoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct RoomView: View {
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    @State private var isShowingSideMenu: Bool = false
    
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {

        ZStack {
            if isShowingSideMenu {
                SideMenuView(isShowing: $isShowingSideMenu, roomData: $roomData)
            }
            ZStack {
                ScrollView {
                    VStack  {
                          
                      
                        LazyVGrid(columns: twoColumnGrid, alignment: .leading) {
                            ForEach($roomData.newItems) { item in
                                VStack{
                                    ItemView(item: item, roomData: $roomData)
                                }
                               
                            }
                        }
         
                        
                        HStack{
                   if (isShowingSideMenu == false) {
                                   NavigationLink {
                                       ItemSearchView()
                                   } label: {
                                       Image(systemName: "sparkle.magnifyingglass").resizable().frame(width: 30, height: 30).foregroundColor(.white)
                                   }.padding()
                                       .buttonStyle(.plain)
                            }
                            
                            Spacer()
                            
                            NavigationLink {
                                ItemCreateView(name: "", qty: "", desc: "",roomData: $roomData)
                            } label: {
                                Image(systemName: "plus.app.fill").resizable().frame(width: 30, height: 30).foregroundColor(.white)
                            }.padding()
                                .buttonStyle(.plain)
                        }

                    }
                }
                .navigationTitle(Text(roomData.title)).foregroundColor(.white)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation(.spring()) {
                                isShowingSideMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.circle.fill").resizable()
                        }.buttonStyle(.plain)

                    }
                }
            }
            .cornerRadius(isShowingSideMenu ? 20 : 10)
            .offset(x: isShowingSideMenu ? screenWidth*0.8 : 0, y: isShowingSideMenu ? screenHeight*0.05 : 0)
            .scaleEffect(isShowingSideMenu ? 0.8 : 1)
        }
        .onAppear {
            isShowingSideMenu = false
        }
           
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(
            roomData: .constant(Room(id: "2dsasdasd", title: "Avent Ferry", newItems: [Item(id: "22020", name: "Coffee", desc: "Coffee is nice", qty: "200gm")], members: ["asdas", "bbasdasd"]))
        )
    }
}
