//
//  BillContributorView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/5/22.
//

import SwiftUI

struct BillContributorView: View {
    
    @State var memberID: String
    @State var roomID: String
    
    @State var avatar: String = "ketchup"
    @State var name: String = ""
    
    @StateObject private var billManager = BillManager()
    @ObservedObject var userInfoProvider = UserInfoProvider()

    
    var body: some View {
        VStack {
            
            Image(avatar).resizable().frame(width: 100, height: 100)

            Text(name).font(.body)
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.bold)
        
        
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Pay: $\(String(format: "%.2f", billManager.toPayAmount))")
                    .font(.footnote).foregroundColor(.white)
                
                Text("Get: $\(String(format: "%.2f", billManager.toGetAmount))")
                    .font(.footnote).foregroundColor(.white)
                
                Text("Net: $\(String(format: "%.2f", billManager.totalAmount))")
                    .font(.footnote).foregroundColor(.white)
  
            }.padding()
             
        }
        .onAppear {
            userInfoProvider.getProfileAvatar(userID: memberID) { res in self.avatar = res }
            userInfoProvider.getProfileName(userID: memberID) { res in self.name = res }
            billManager.updateRoomID(name: roomID)
            billManager.updateToGet(contributorID: memberID)
            billManager.updateToPay(contributorID: memberID)
        }


    }
}

//
//struct BillContributorView_Previews: PreviewProvider {
//    static var previews: some View {
//        BillContributorView( memberID: "1234", roomID: "4231").environmentObject(AuthViewModel())
//    }
//}
