//
//  ItemSearchView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/20/22.
//

import SwiftUI

struct ItemSearchView: View {
    let names = assetName.sorted()
    @State private var searchText = ""
    @Binding var recentlyDeleted: [String]

    var body: some View {
        VStack {
          
            if recentlyDeleted.count>0 {
                VStack{
                    Text("Quick Undo").font(.title2).foregroundColor(.blue)
                    HStack {
                        ForEach(recentlyDeleted, id: \.self) { item in
                            Image(item.sanitiseItemName()).resizable().frame(width: 50, height: 50)
                        }
                    }
                }
            }
            
            ZStack{
                 

                    List {
                        ForEach(searchResults, id: \.self) { name in
                            NavigationLink(destination: Text(name)) {
                                Text(name)
                            }
                        }
                    }
                    .searchable(text: $searchText) {
                        ForEach(searchResults, id: \.self) { result in
                            Text(result).searchCompletion(result)
                        }
                    }
                    .navigationTitle("Items")
                
            }
        }
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}

struct ItemSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ItemSearchView(recentlyDeleted: .constant(["coffee", "apple", "tomato"]))
            .preferredColorScheme(.light)
    }
}
