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
    
    @Binding var lastDeleted: [Item]
    
    @Binding var item: Item
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State var isShowing: Bool = true
    @State var isEditing: Bool = false
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
  
        if isShowing {
            ZStack {
                HStack{
                   
                    NavigationLink{
                        ItemEditView(item: item, name: item.name, desc: item.desc, qty: item.qty, roomID: roomData.id ?? "", offset: $offset  )
                        
                    } label: {
                        if offset.width != 0 {
                            Image("editItemBack").resizable().frame(width: cardWidth, height: 195)
                        }
                    }.buttonStyle(.plain)
                    
                }.onTapGesture {
                    withAnimation(.spring()) {
                        offset.width = 0
                    }
            }
                
                VStack{

                        VStack{
                            Image(item.name.sanitiseItemName()).resizable().frame(width: 100, height: 100, alignment: .leading)
                           
                            HStack{
                                Text(item.name.capitalized).font(.headline).foregroundColor(.white).fontWeight(.bold)

                                Text("\(item.qty)").font(.subheadline).foregroundColor(.white).fontWeight(.light)
                            }.padding(.vertical, 2)

                            Text(item.desc)
                                .foregroundColor(.white)
                                .font(.footnote)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 10)
                                

                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                offset.width = 0
                            }
                    }

 
                }
                .frame(minWidth: cardWidth, idealWidth: cardWidth, maxWidth: cardWidth, minHeight: 195, idealHeight: 195, maxHeight: 195 )
                .background(Color("MediumBlue"))
                .onLongPressGesture(perform: {
                    lastDeleted.append(item)
                    withAnimation (.spring()) {
                        isShowing.toggle()
                    }
                    hapticFeedback.notificationOccurred(.success)
                    DispatchQueue.main.async {
                        viewModel.deleteItem(del: item, roomID: roomData.id ?? "")
                    }
                    
                    
                    
   
                })
                .onTapGesture {
                        withAnimation(.spring()) {
                            offset.width = 0
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
            .frame(minWidth: cardWidth, idealWidth: cardWidth, maxWidth: cardWidth, minHeight: 195, idealHeight: 195, maxHeight: 195 )

        }
      

    }
    
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView(lastDeleted: ["coffee"], item: .constant(Item(id: "2sda", name: "Coffee", desc: "Coffee is hot", qty: "200 gm")),
//                 roomData: .constant(Room(title: "Avent Ferry", newItems: [], members: ["a","b"]))
//                ).previewLayout(.sizeThatFits)
//    }
//}
