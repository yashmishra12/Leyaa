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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SplitBillView_Previews: PreviewProvider {
    static var previews: some View {
        SplitBillView(roomData: .constant(Room(id: "123", title: "Avent Ferry", newItems: [], members: [])))
    }
}
