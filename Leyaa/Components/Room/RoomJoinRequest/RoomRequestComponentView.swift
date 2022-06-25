//
//  RoomRequestComponentView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/24/22.
//

import SwiftUI

struct RoomRequestComponentView: View {
    @Binding var reqData: RoomRequest
    
    var body: some View {
        VStack {
            HStack{
                Text(reqData.roomName ).font(.title).foregroundColor(.white)
                Spacer()
            }.padding(.horizontal, 10)
            
            HStack{
                let senderNameText = "By: \(reqData.senderName ?? "")"
                Text(senderNameText).font(.title3).foregroundColor(.white).padding(.vertical, 1)
                Spacer()
            }.padding(.horizontal, 10)
            
            
            if (reqData.message != nil) {
                HStack{
                    let messageText = "Message: \(reqData.message ?? "" )"
                    Text(messageText).font(.body).foregroundColor(.white).padding(.vertical, 2)
                    Spacer()
                }.padding(.horizontal, 10)
            }

  
            
            HStack{
                Button {
                    print("rejected")
                } label: {
                    Image(systemName: "minus.rectangle.fill").resizable().frame(width: 40, height: 40).tint(.red)
                }.padding(.horizontal, 50)
                    .padding(.vertical, 10)
                
                Spacer()
                Button {
                    print("accepted")
                } label: {
                    Image(systemName: "plus.rectangle.fill").resizable().frame(width: 40, height: 40).tint(.green)
                }.padding(.horizontal, 50)
                    .padding(.vertical, 10)

            }
        }.background(Color("MediumBlue"))
            
    }
}

struct RoomRequestComponentView_Previews: PreviewProvider {
    static var previews: some View {
        RoomRequestComponentView(reqData: .constant(RoomRequest(roomID: "", roomName: "", senderID: "", receiverEmail: ""))).previewLayout(.sizeThatFits)
    }
}
