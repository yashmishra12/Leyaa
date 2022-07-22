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
    @State var recentDeletedItems: [Item]
    
    @State private var isShowingSideMenu: Bool = false
    
    
    @State var lastItemID: String = ""
    
    
    
    func updateLastItemID(newID: String) {
        self.lastItemID = newID
    }
    
    var body: some View {
        
        ZStack {
            if isShowingSideMenu {
                SideMenuView(isShowing: $isShowingSideMenu, roomData: $roomData, show: $isShowingSideMenu)
            }
            
            VStack {
                if roomData.newItems.count==0 && isShowingSideMenu==false {
                    Image ("noItem").resizable().aspectRatio(contentMode: .fit).padding()

                }
                
                
            }
            
            VStack {
                ScrollViewReader { proxy in
                    
                    ScrollView {
                        
                            LazyVGrid(columns: twoColumnGrid, alignment: .leading) {
                                ForEach(roomData.newItems, id: \.id) { item in
                                    
                                    VStack{
                                        ItemView(lastDeleted: $recentDeletedItems, item: item, roomData: roomData)
                                            .padding(.bottom, -3)
                                            .onTapGesture {
                                                withAnimation {
                                                    isShowingSideMenu = false
                                                }
                                            }
                                    }.id(item.id)
                                    
                                }
                            }

                        
                        .onChange(of: roomData.lastItemID) { id in
                            
                            withAnimation(.easeInOut) { proxy.scrollTo(id, anchor: .bottom) }
                        }
                        .onAppear(perform: {
                            withAnimation(.easeInOut) {
                                proxy.scrollTo(roomData.lastItemID, anchor: .bottom)
                            }
                        })
                        
                    }
                }
                .onTapGesture {
                    withAnimation (.spring()) {
                        isShowingSideMenu = false
                    }
                }
                
                .toolbar {
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
                        if isShowingSideMenu == false {
                            
                            //Member Add
                            
                            NavigationLink {
                                RoomInviteView(roomData: $roomData).hideKeyboardWhenTappedAround()
                            } label: {
                                HStack {
                                    Image(systemName: "person.fill.badge.plus")
                                        .imageScale(.large)
                                        .padding(.horizontal, 10)
                                    
                                }
                            }.buttonStyle(.plain)
                            
                            
                            //QuickSearch
                            
                            NavigationLink {
                                ItemSearchView(recentlyDeleted: $recentDeletedItems, room: $roomData)
                            } label: {
                                Image(systemName: "text.magnifyingglass").imageScale(.large)
                                    .padding(.horizontal, 10)
                            }.buttonStyle(.plain)
                            
                            
                            
                            
                            //Add
                            
                            NavigationLink {
                                ItemCreateView(name: "", qty: "", desc: "",roomData: $roomData).hideKeyboardWhenTappedAround()
                            } label: {
                                Image(systemName: "plus.app.fill").imageScale(.large)
                            }.padding(.horizontal, 10)
                                .buttonStyle(.plain)
                            
                        }
                        
                        
                        
                    }
                    
                    //Hamburger
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation(.spring()) {
                                isShowingSideMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal").imageScale(.large)
                                .padding(.leading)
                                .padding(.top)
                                .padding(.bottom)
                            
                            
                        }.buttonStyle(.plain)
                        
                        
                    }
                }
                
                .cornerRadius(isShowingSideMenu ? 20 : 10)
                .offset(x: isShowingSideMenu ? screenWidth*0.8 : 0, y: isShowingSideMenu ? screenHeight*0.05 : 0)
                .scaleEffect(isShowingSideMenu ? 0.8 : 1)
            }
            .onAppear(perform: {
                lastItemID = roomData.lastItemID ?? ""
            })
            .navigationTitle(Text(roomData.title))
            .navigationBarTitleDisplayMode(.automatic)
           
        }
    }
    
    struct RoomView_Previews: PreviewProvider {
        static var previews: some View {
            RoomView(
                roomData: .constant(Room(id: "2dsasdasd", title: "Avent Ferry", newItems: [Item(id: "22020", name: "Coffee", desc: "Coffee is nice", qty: "200gm")], members: ["asdas", "bbasdasd"])), recentDeletedItems: []
            )
        }
    }
    
    
}
