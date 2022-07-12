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
    @Environment(\.scenePhase) var scenePhase
    @State private var relaxedPhoto: String = "relax1"
    
    var body: some View {
        NavigationView{
            if viewModel.pendingReqest.count > 0 {
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
            }
            else {
              
                VStack {
                    Text("Relax.\nNo New Request")
                        .font(.title)
                        .fontWeight(.bold)
                        .kerning(1.2)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                    Image(relaxedPhoto).resizable().aspectRatio(contentMode: .fit).padding()
                    Spacer()
                }
              
            }
           
        }
        .navigationViewStyle(.stack)
        .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                            relaxedPhoto = relaxPic.randomElement() ?? "relax1"
                        }
        }
    }
}

struct RoomJoinRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RoomJoinRequestView(roomRequest: .constant([RoomRequest(roomID: "", roomName: "", senderName: "", receiverEmail: "")])).environmentObject(AuthViewModel())
    }
}
