//
//  RoomRequestComponentView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/24/22.
//

import SwiftUI

struct RoomRequestComponentView: View {
    @Binding var reqData: RoomRequest
    @State private var rejectingRequest: Bool = false
    @State private var acceptingRequest: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            HStack{
                Text(reqData.roomName ).font(.title).foregroundColor(.white)
                Spacer()
            }.padding(.horizontal, 10)
            
            HStack{
                if (reqData.senderName.isEmpty == false) {
                    let senderNameText = "By: \(reqData.senderName )"
                    Text(senderNameText).font(.title3).foregroundColor(.white).padding(.vertical, 1)
                    Spacer()
                }
            }.padding(.horizontal, 10)
            
            
            if (reqData.message?.isEmpty == false) {
                HStack{
                    let messageText = "Message: \(reqData.message ?? "" )"
                    Text(messageText).font(.body).foregroundColor(.white).padding(.vertical, 2)
                    Spacer()
                }.padding(.horizontal, 10)
            }

  
            
            HStack{
                 
                // REJECT ROOM JOIN REQUEST
                Button(action: {
                    rejectingRequest = true
                }, label: {
                    Image(systemName:"minus.rectangle.fill").resizable().frame(width: 40, height: 40).padding().foregroundColor(.red)
                }).buttonStyle(.plain)
                .confirmationDialog("Are you sure?",
                  isPresented: $rejectingRequest) {
                  Button("Leave Room", role: .destructive) {
                      viewModel.rejectRoomRequest(reqData: reqData)
                      
                  }
                } message: {
                  Text("One of the group members will have to add you back")
                }
                
                
                Spacer()
                
                
                Button(action: {
                    acceptingRequest = true
                }, label: {
                    Image(systemName:"plus.rectangle.fill").resizable().frame(width: 40, height: 40).padding().foregroundColor(.green)
                }).buttonStyle(.plain)
                .confirmationDialog("Are you sure?",
                  isPresented: $acceptingRequest) {
                    Button("Accept", role: .none) {
                      viewModel.acceptRoomRequest(reqData: reqData)
                  }
                } message: {
                  Text("Make sure not to accept strange request")
                }
                
                
            }
        }.background(Color("MediumBlue"))
            
    }
}

struct RoomRequestComponentView_Previews: PreviewProvider {
    static var previews: some View {

        RoomRequestComponentView(reqData: .constant(RoomRequest(roomID: "", roomName: "", senderName: "", receiverEmail: ""))).previewLayout(.sizeThatFits)
    }
}
