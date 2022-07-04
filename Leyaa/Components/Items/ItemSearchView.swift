//
//  ItemSearchView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/20/22.
//

import SwiftUI

struct ItemSearchView: View {
    let names = assetName.map{$0.capitalized}.sorted()
    @State private var searchText = ""
    @Binding var recentlyDeleted: [Item]
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var room: Room
    
    var body: some View {
        ZStack {
            
        
            //MARK: - SEARCH LIST
            
            VStack {
                
                List {
                    ForEach(searchResults, id:\.self) { item in
                        Button {
                            viewModel.addItem(item: ["id":UUID().uuidString, "name": item, "desc":"", "qty": ""],
                                              roomID: room.id ?? "")
                        } label: {
                            Text(item)
                        }
                        
                        
                    }
                }
                .searchable(text:  $searchText)
                
                
                
                Spacer()
                
                VStack {
                    if recentlyDeleted.count>0 {
                        VStack{
                            Divider()
                            Text("Undo Delete an Item").font(.title2).foregroundColor(.blue).padding(.top)
                            HStack {
                                ForEach(recentlyDeleted.suffix(5), id: \.self) { item in
                                    VStack {
                                        Image(item.name.sanitiseItemName()).resizable().frame(width: 50, height: 50).shadow(color: .white, radius: 1)
                                        Text(item.name).font(.footnote).padding(.bottom, 10)
                                    }
                                        .onTapGesture {
                                            let newItem: [String: String] = [
                                                "id": item.id,
                                                "name": item.name,
                                                "desc": item.desc,
                                                "qty": item.qty
                                            ]
                                            
                                            viewModel.addItem(item: newItem, roomID: room.id ?? "")
                                            recentlyDeleted = recentlyDeleted.filter { $0 != item }
                                        }
                                }
                            }
                        }
                    }
                }
                
            }
            
            
            
            
        }
        .navigationTitle("Items")
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}
//
//struct ItemSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemSearchView(recentlyDeleted: .constant(["coffee", "apple", "tomato"]), room: "")
//            .preferredColorScheme(.light)
//    }
//}
