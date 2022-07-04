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
                Text(reqData.roomName )
                    .font(.title2)
                    .fontWeight(.bold)
                    
                    .foregroundColor(.white)
                Spacer()
            }  .padding(.leading, 20)
                .padding(.top, 10)
            
            HStack{
                if (reqData.senderName.isEmpty == false) {
                    let senderNameText = "By: \(reqData.senderName )"
                    Text(senderNameText).font(.body).foregroundColor(.white).padding(.vertical, 1)
                        .padding(.leading, 20)
                    Spacer()
                }
            }
            
            
            if (reqData.message?.isEmpty == false) {
                HStack{
                    let messageText = "Message: \(reqData.message ?? "" )"
                    Text(messageText).font(.footnote).foregroundColor(.white).padding(.vertical, 2)
                    Spacer()
                }.padding(.horizontal, 20)
            }

  
            
            HStack{
                 
                // REJECT ROOM JOIN REQUEST
                Button(action: {
                    rejectingRequest = true
                }, label: {
                    Image(systemName:"xmark.rectangle.fill")
                        .resizable()
                        .frame(width: 40, height: 30)
                        .padding(.leading, 20)
                        .padding()
                        .foregroundColor(Color("reject"))
                }).buttonStyle(.plain)
                .confirmationDialog("Are you sure?",
                  isPresented: $rejectingRequest) {
                  Button("Reject Request", role: .destructive) {
                      viewModel.rejectRoomRequest(reqData: reqData)
                      
                  }
                } message: {
                  Text("Are you sure?")
                }
                
                
                Spacer()
                
                
                Button(action: {
                    acceptingRequest = true
                }, label: {
                    Image(systemName:"checkmark.rectangle.fill")
                        .resizable()
                        .frame(width: 40, height: 30)
                        .padding(.trailing, 20)
                        .padding()
                        .foregroundColor(Color("accept"))
                }).buttonStyle(.plain)
                .confirmationDialog("Are you sure?",
                  isPresented: $acceptingRequest) {
                    Button("Accept", role: .none) {
                      viewModel.acceptRoomRequest(reqData: reqData)
                  }
                }
                
                
            }
        }.background(Color("MediumBlue"))
            
    }
}

struct RoomRequestComponentView_Previews: PreviewProvider {
    static var previews: some View {

        RoomRequestComponentView(reqData: .constant(RoomRequest(roomID: "12", roomName: "Upside Down", senderName: "Yash Mishra", receiverEmail: "yashmishra@mf.com"))).previewLayout(.sizeThatFits)
    }
}
