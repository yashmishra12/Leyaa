//
//  SplitBillView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/4/22.
//

import SwiftUI

struct SplitBillView: View {
    @Binding var roomData: Room
    @EnvironmentObject var viewModel: AuthViewModel
    @State var userInfo: [[String]]
    

    
    var body: some View {
        VStack {
            
            NavigationLink {
                BillCreateView(roomData: $roomData, memberAmount: Array(repeating: 0.0, count: roomData.members.count)
)
            } label: {
                Text("Add Bill").buttonStyle()
            }.buttonStyle(.plain)

        }.onAppear {
            userInfo = viewModel.populateUserInfo(memberID: roomData.members)
        }
    }
}

struct SplitBillView_Previews: PreviewProvider {
    static var previews: some View {
        SplitBillView(roomData: .constant(Room(id: "123", title: "Avent Ferry", newItems: [], members: [])), userInfo: [[""]])
    }
}
