//
//  ItemView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/19/22.
//

import SwiftUI

struct ItemView: View {
    @Binding var item: Item
    var body: some View {
        VStack{
            HStack{
                Image(item.name).resizable().frame(width: 100, height: 100, alignment: .leading)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                
                Text(item.name).font(.title)
                Spacer()
                VStack{
                    Text("Qty: \(item.qty)").font(.title3)
                }.padding(.horizontal, 15)
            }
            
            Spacer()
            
            HStack {
                Text(item.desc)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
            }
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: .constant(Item(name: "", desc: "", qty: "", assignedTo: "")))
    }
}
