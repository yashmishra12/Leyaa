//
//  ItemView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/19/22.
//

import SwiftUI

struct ItemView: View {
    
    @State var offset: CGSize = .zero
    @State var triggerOffset = UIScreen.main.bounds.width / 6
    
    @Binding var item: Item
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State var isShowing: Bool = true
    @State var isEditing: Bool = false

    
    var body: some View {
  
        if isShowing {
            ZStack {
                HStack{
                   
                    NavigationLink{
                        ItemEditView(item: item, name: item.name, desc: item.desc, qty: item.qty, roomID: roomData.id ?? "" )
                    } label: {
                        Image("editItemBack").resizable().frame(width: 180, height: 210)
                    }
                    
     
                   
                    Spacer()


                }
                
                VStack{

                        VStack{
                            Image(item.name.sanitiseItemName()).resizable().frame(width: 100, height: 100, alignment: .leading)
                            Text(item.name.capitalized).font(.headline).fontWeight(.bold).padding()

                            Text("\(item.qty)").font(.subheadline).fontWeight(.light).padding(.horizontal, 5)

                            Text(item.desc)
                                .font(.footnote)
                                .multilineTextAlignment(.leading)

                        }

 
                }
                .frame(minWidth: 195, idealWidth: 195, maxWidth: 195, minHeight: 210, idealHeight: 210, maxHeight: 210 )
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
                            withAnimation(.interactiveSpring()) {
                                offset = value.translation
    
                                if offset.width<0 {
                                    offset = .zero
                                }
                                if offset.width>triggerOffset {
                                    offset.width = triggerOffset
                                }
                  
                                
                            }
                        }
                        .onEnded({ value in
                            withAnimation(.interactiveSpring()) {
                                if (offset.width < triggerOffset) {
                                    offset.width = 0
                                }
                            }
                        })
                    )
                
                
            }
            .frame(minWidth: 195, idealWidth: 195, maxWidth: 195, minHeight: 210, idealHeight: 210, maxHeight: 210 )

        }
      

    }
    
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: .constant(Item(id: "2sda", name: "Coffee", desc: "Coffee is hot", qty: "200 gm")),
                 roomData: .constant(Room(title: "Avent Ferry", newItems: [], members: ["a","b"]))
                ).previewLayout(.sizeThatFits)
    }
}
