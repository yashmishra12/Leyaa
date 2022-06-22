//
//  ItemSearchView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/20/22.
//

import SwiftUI

struct ItemSearchView: View {
    let names = ["milk", "bread", "apple", "carrot", "egg", "cheese"].sorted()
    @State private var searchText = ""

    var body: some View {
        ZStack{
            NavigationView {
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
        ItemSearchView()
            .preferredColorScheme(.light)
    }
}
