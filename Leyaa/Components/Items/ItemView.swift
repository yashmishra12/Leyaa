//
//  ItemView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/19/22.
//

import SwiftUI



struct ItemView: View {
    
    @Binding var lastDeleted: [Item]
    
    @State var item: Item
    @State var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    let itemManager = ItemManager()
    var body: some View {
        
        
        ZStack
        {
            VStack{
                HStack {
                    Image(item.name.sanitiseItemName()).resizable().frame(width: 100, height: 100, alignment: .center)
                }
                
                
                HStack{
                    Text(item.name.capitalized).font(.headline).foregroundColor(.white).fontWeight(.bold)
                    
                    Text("\(item.qty)").font(.subheadline).foregroundColor(.white).fontWeight(.light)
                    
                }.padding(.vertical, 2)
                
                HStack {
                    Text(item.desc)
                        .foregroundColor(.white)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    
                    
                }
                
            
            

            
        }
            
            
            VStack {
               
              
                HStack {
                    NavigationLink{
                        ItemEditView(item: item, name: item.name, desc: item.desc, qty: item.qty, roomID: roomData.id ?? "").hideKeyboardWhenTappedAround()
                        
                    }
                    label: {
                            Image(systemName: "pencil.circle").resizable().frame(width: 20, height: 20).foregroundColor(Color("cardEdit"))
                        }.buttonStyle(.plain)
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        lastDeleted.append(item)
                        
                        hapticFeedback.notificationOccurred(.success)
                        
                        itemManager.deleteItem(del: item, roomID: roomData.id ?? "")
                        
                    } label: {
                        Image(systemName: "x.circle").resizable().frame(width: 20, height: 20).foregroundColor(Color("cardEdit"))
                    }.buttonStyle(.plain)
                        .padding()
                }
             
                    
                Spacer()
            }
        }
        .frame(minWidth: cardWidth, idealWidth: cardWidth, maxWidth: cardWidth, minHeight: 200, idealHeight: 200, maxHeight: 200 )
        .background(Color("MediumBlue"))
        
        
        
        
    
        
        
        
    }
    
}
//
//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView(lastDeleted: ["coffee"], item: ([Item(id: "2sda", name: "Coffee", desc: "Coffee is hot", qty: "200 gm")]),
//                 roomData: (Room(title: "Avent Ferry", newItems: [], members: ["a","b"]))
//                ).previewLayout(.sizeThatFits)
//    }
//}
