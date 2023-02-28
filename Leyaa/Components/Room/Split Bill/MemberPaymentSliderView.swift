//
//  MemberPaymentSliderView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/4/22.
//

import Foundation

import SwiftUI

struct MemberPaymentSliderView: View {
 
    @State var userID: String
    @State var avatar = "ketchup"
    @State var name = "Loading..."
    @Binding var maxAmount: Double
    @Binding var memberAmount: [Double]
    
    @Binding var currentAmount: Double
    @State var index: Int
    @State private var isShowingTextField: Bool = false
    
    var isEditing: FocusState<Bool>.Binding
    
    let userInfoProvider = UserInfoProvider()
    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        
        
        VStack {
            
            //Top Layer Without Manual Control
            HStack {
                
                //Avatar
                    Image(avatar).resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(width: 50, height: 50)

                //Name
                Text(name).font(.body)
                
                Spacer()
                
                TextField("Amount", value: $currentAmount, formatter: formatterAmount)
                    .font(.callout)
                    .focused(isEditing)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .autocapitalization(.none)
                    .foregroundColor(.blue)
                    .frame(minWidth: 50)
                
                Image(systemName: "pencil").resizable().frame(width: 10, height: 10).foregroundColor(.blue)
            }
               
        }
        .padding(.horizontal, 15)
        
        .onAppear(perform: {
            userInfoProvider.getProfileAvatar(userID: userID) { res in self.avatar = res }
           
            if userID == viewModel.currentUser?.id {
                self.name = "You"
            } else {
                userInfoProvider.getProfileName(userID: userID) { res in self.name = res }
            }
          
        })
    }
}

//
//struct MemberPaymentSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemberPaymentSliderView(userID: "1234", maxAmount: .constant(200), memberAmount: .constant([1.2, 1.5, 2.4]), currentAmount: .constant(40.0), index: 2, isEditing: false).environmentObject(AuthViewModel())
//    }
//}
