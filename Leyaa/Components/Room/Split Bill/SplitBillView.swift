//
//  SplitBillView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/4/22.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct SplitBillView: View {
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State var userInfo: [[String]]
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            VStack {
                
                ScrollView {
                    VStack {
                        LazyVGrid(columns: twoColumnGrid, alignment: .center) {
                            ForEach(roomData.members, id:\.self) { memberID in
                                if memberID != viewModel.currentUser?.id {
                                    NavigationLink {
                                        DetailedBillView(memberID: memberID, roomID: roomData.id ?? "", roomName: roomData.title, memberName: "")
                                    } label: {
                                        BillContributorView(memberID: memberID, roomID: roomData.id ?? "")
                                            .frame(width: screenWidth*0.5)
                                            .background(Color("MediumBlue"))

                                    }.buttonStyle(.plain)

                                }
                            }
                        }
                    }
                }
                
                
                NavigationLink {
                    BillCreateView(roomData: $roomData, memberAmount: Array(repeating: 0.0, count: roomData.members.count))
                } label: {
                    Text("Add Bill").buttonStyle()
                }.buttonStyle(.plain)
                    .padding(.bottom, 30)

            }.onAppear {
                userInfo = viewModel.populateUserInfo(memberID: roomData.members)
        }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct SplitBillView_Previews: PreviewProvider {
    static var previews: some View {
        SplitBillView(roomData: .constant(Room(id: "123", title: "Avent Ferry", newItems: [], members: [])), userInfo: [[""]])
    }
}
