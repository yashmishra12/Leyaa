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
                        }
                    }
                    
                    Spacer()
                   
                    Button {
                        print(UserDefaults.standard.string(forKey: "kDeviceToken") )
                    } label: {
                        Text("Print Me")
                    }



                }
            }.navigationTitle("Room Request")
        }
    }
}

struct RoomJoinRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RoomJoinRequestView(roomRequest: .constant([RoomRequest(roomID: "", roomName: "", senderName: "", receiverEmail: "")]))
    }
}
