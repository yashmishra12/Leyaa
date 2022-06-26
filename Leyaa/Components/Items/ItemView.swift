//
//  ItemView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/19/22.
//

import SwiftUI

struct ItemView: View {
    @Binding var item: Item
//    @State var offset: CGSize = .zero
//    @State var triggerOffset = UIScreen.main.bounds.width / 2
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State var isShowing: Bool = true
    
    var body: some View {
  
        if isShowing {
            ZStack {
    //            HStack{
    //                if offset.width>0 {
    //                    Color(uiColor: UIColor(red: 0.42, green: 0.70, blue: 0.42, alpha: 1.00))
    //                }
    //                if offset.width<0 {
    //                    Color(uiColor: UIColor(red: 1.00, green: 0.37, blue: 0.31, alpha: 1.00))
    //                }
    //            }
                
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
                    withAnimation (.easeOut(duration: 0.3)) {
                        isShowing.toggle()
                    }
                    DispatchQueue.main.async {
                        viewModel.deleteItem(del: item, roomID: roomData.id ?? "")
                    }
                }
                .onLongPressGesture(minimumDuration: 1) {
                    print("YAYAYAYAYYA")
                }
    //            .offset(CGSize(width: offset.width, height: 0))
    //                .gesture(DragGesture()
    //                    .onChanged{ value in
    //                        withAnimation(.linear) {
    //                            offset = value.translation
    //
    //                            if offset.width<0 && abs(offset.width)>triggerOffset {
    //                                DispatchQueue.main.async {
    //                                    viewModel.deleteItem(del: item, roomID: roomData.id ?? "")
    //                                }
    //                                offset = .zero
    //                            }
    //                        }
    //                    }
    //                    .onEnded{ value in
    //                        withAnimation(.linear) {
    //                            offset = .zero
    //                        }
    //                    }
    //                )
                
                
            }
        }
      

    }
    
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: .constant(Item(id: "", name: "", desc: "", qty: "", assignedTo: "")), roomData: .constant(Room(title: "", newItems: [], members: [])))
    }
}
