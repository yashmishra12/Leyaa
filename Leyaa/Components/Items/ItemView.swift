//
//  ItemView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/19/22.
//

import SwiftUI

struct ItemView: View {
    
    @State var offset: CGSize = .zero
    @State var triggerOffset = UIScreen.main.bounds.width / 4
    
    @Binding var item: Item
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State var isShowing: Bool = true
    

    
    var body: some View {
  
        if isShowing {
            ZStack {
                HStack{
                  
                    NavigationLink{
                        
                        ItemEditView(item: item, name: item.name, desc: item.desc, qty: item.qty, roomID: roomData.id ?? "" )
                    } label: {
                        ZStack {
                            Color(uiColor: UIColor(red: 0.42, green: 0.70, blue: 0.42, alpha: 1.00))
                        }
                    }

                }
                
                VStack{
                    HStack{
                        Image(item.name.sanitiseItemName()).resizable().frame(width: 100, height: 100, alignment: .leading)
                        
                        Text(item.name.capitalized).font(.title)
                        Spacer()
                        if(item.qty.isEmpty == false){
                            VStack{
                                Text("\(item.qty)").font(.title3)
                            }.padding(.horizontal, 15)
                        }
                    }
                    
                    Spacer()
                    
                    if(item.desc.isEmpty == false) {
                        HStack {
                            Text(item.desc)
                                .font(.callout)
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                        }
                    }
                }
                .padding(.vertical, 1)
                .background(Color("MediumBlue"))
                .onTapGesture {
                    if (offset.width != 0 ) {
                        withAnimation(.easeIn) {
                            offset.width = 0
                        }
                    }
                    else {
                        withAnimation (.easeOut(duration: 0.3)) {
                            isShowing.toggle()
                        }
                        DispatchQueue.main.async {
                            viewModel.deleteItem(del: item, roomID: roomData.id ?? "")
                        }
                    }
                }

                .offset(CGSize(width: offset.width, height: 0))
                    .gesture(DragGesture()
                        .onChanged{ value in
                            withAnimation(.linear) {
                                offset = value.translation
    
                                if offset.width<0 {
                                    offset = .zero
                                }
                                if offset.width>triggerOffset {
                                    offset.width = triggerOffset
                                }
                            }
                        }

                    )
                
                
            }
        }
      

    }
    
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: .constant(Item(id: "", name: "", desc: "", qty: "")), roomData: .constant(Room(title: "", newItems: [], members: [])))
    }
}
