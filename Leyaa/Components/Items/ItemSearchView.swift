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
    
    let itemManager = ItemManager()
    
    var body: some View {
        ZStack {
            
            //MARK: - SEARCH LIST
            VStack {
                List {
                    ForEach(searchResults, id:\.self) { item in
                        Button {
                            itemManager.addItem(item: ["id":UUID().uuidString,
                                                       "name": item,
                                                       "desc":"",
                                                       "qty": ""],
                                              roomID: room.id ?? "")
                            
                            searchText = ""
                            successSBItemAdded(title: "Item Added")
                        }
                        label: {
                                Text(item)
                            }
                    }
                }
                .searchable(text:  $searchText,
                            placement: .navigationBarDrawer(displayMode: .always)
                )
                
                Spacer()
                
               //MARK: - Undo Delete
                VStack {
                    if recentlyDeleted.count>0 {
                        VStack{
                            Divider()
                            Text("Undo Delete").font(.title2).foregroundColor(.blue).padding(.top)
                            HStack {
                                ForEach(recentlyDeleted.suffix(5), id: \.self) { item in
                                    VStack {
                                        Image(item.name.sanitiseItemName()).resizable().frame(width: 50, height: 50).shadow(color: .blue, radius: 1)
                                        Text(item.name).font(.footnote).padding(.bottom, 10)
                                    }
                                        .onTapGesture {
                                            let newItem: [String: String] = [
                                                "id": item.id,
                                                "name": item.name,
                                                "desc": item.desc,
                                                "qty": item.qty
                                            ]
                                            
                                            itemManager.addItem(item: newItem, roomID: room.id ?? "")
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
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                focusSearchBar()
            }
        }
    }
    
    private func focusSearchBar() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        func findSearchBar(in view: UIView) -> UISearchBar? {
            if let searchBar = view as? UISearchBar { return searchBar }
            for subview in view.subviews {
                if let found = findSearchBar(in: subview) { return found }
            }
            return nil
        }
        
        if let searchBar = findSearchBar(in: window) {
            searchBar.becomeFirstResponder()
        }
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            if names.filter({ $0.contains(searchText) }).isEmpty {
                return [searchText]
            }
            else
                {
                    return names.filter {$0.contains(searchText)}
            }
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
