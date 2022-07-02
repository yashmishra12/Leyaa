//
//  RoomJoinRequestView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/24/22.
//

import SwiftUI

struct RoomJoinRequestView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var roomRequest: [RoomRequest]

    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack{
                    VStack{
                        ForEach($roomRequest, id: \.self) { req in
                            RoomRequestComponentView(reqData: req)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2.5)
                        }
                    }
                    
                    Spacer()




                }
            }.navigationTitle("Room Request")
        }.onAppear {
                viewModel.roomJoinRequestUpdate()
        }
    }
}

struct RoomJoinRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RoomJoinRequestView(roomRequest: .constant([RoomRequest(roomID: "", roomName: "", senderName: "", receiverEmail: "")]))
    }
}
