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
    
    
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        ZStack {
            if isShowingSideMenu {
                SideMenuView(isShowing: $isShowingSideMenu, roomData: $roomData, show: $isShowingSideMenu)
            }
            
            VStack {
                if roomData.newItems.count==0 && isShowingSideMenu==false {
                    Text("Right Slide Items to Edit.\n\nLong Press on Items to Delete.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                
            }
            
            ScrollView {
                VStack  {
                    LazyVGrid(columns: twoColumnGrid, alignment: .leading) {
                        ForEach($roomData.newItems) { item in
                            VStack{
                                ItemView(lastDeleted: $recentDeletedItems, item: item, roomData: $roomData)
                            }
                            
                        }
                    }
                    
                    
                    
                }
            }
    
            

            
            .toolbar {
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    if isShowingSideMenu == false {
                        
                        //Quick Add
                        
                        NavigationLink {
                            RoomInviteView(roomData: $roomData)
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
                            ItemCreateView(name: "", qty: "", desc: "",roomData: $roomData)
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
                    }.buttonStyle(.plain)
                    
                }
            }
            
            .cornerRadius(isShowingSideMenu ? 20 : 10)
            .offset(x: isShowingSideMenu ? screenWidth*0.8 : 0, y: isShowingSideMenu ? screenHeight*0.05 : 0)
            .scaleEffect(isShowingSideMenu ? 0.8 : 1)
        }
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

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
