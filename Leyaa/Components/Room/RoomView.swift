//
//  RoomView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI

struct RoomView: View {
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                  
                HStack{
                    Text(roomData.title).font(.largeTitle).foregroundColor(.white).multilineTextAlignment(.leading)
                    
                    Spacer()
                    }
                
                ForEach(roomData.newIetms, id: \.self) { item in
                    VStack{
                        HStack{
                            Image(item).resizable().frame(width: 100, height: 100, alignment: .leading).padding(.horizontal, 50)
                            
                            Text(item).font(.title)
                        }
                        
                    }
                }
                    
                Spacer()
                
    //
    //            AsyncImage(
    //                url: URL(string: viewModel.userData.profileImageUrl),
    //              content: { image in
    //              image
    //                .resizable()
    //                .aspectRatio(contentMode: .fit)
    //            }, placeholder: {
    //              Color.gray
    //            })
    //              .frame(width: 100, height: 100)
    //              .mask(RoundedRectangle(cornerRadius: 16))

            }.padding(.horizontal, 2)
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(
            roomData: .constant(Room(id: "", title: "", newIetms: [""], oldItems: [""], members: [""]))
        )
    }
}
