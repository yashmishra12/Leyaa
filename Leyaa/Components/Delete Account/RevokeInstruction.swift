//
//  RevokeInstruction.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/17/22.
//

import SwiftUI
import AuthenticationServices

struct RevokeInstruction: View {
    
    
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var accountDeleteManager: AccountDeleteManager
    @State var isRevoked: Bool = false
    
    var body: some View {
        
            VStack {
                Text("Follow The Instructions Below: ").font(.title3)
                    .multilineTextAlignment(.leading)
                Image("deleteFlow1").resizable().frame(width: screenWidth).aspectRatio(contentMode: .fit)
                Divider().padding(.vertical, 2)
                Image("deleteFlow2").resizable().frame(width: screenWidth).aspectRatio(contentMode: .fit)
                
                Text("'Next' will be enabled once you tap 'Stop Using Apple ID' and come back here.")
                    .font(.footnote)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Text("Do not close the app by swiping up.")
                    .font(.footnote)
                    .padding()
                    .multilineTextAlignment(.center)

                
                NavigationLink {
                    DeleteAccountData()
                } label: {
                    Text("Next").padding(.vertical, -2)
                }.buttonStyle()
                    .buttonStyle(.plain)
                    .disabled(accountDeleteManager.isAppleAuthRevoked == false)
               
            }

       
    }
}

//struct RevokeInstruction_Previews: PreviewProvider {
//    static var previews: some View {
//        RevokeInstruction(, accountDeleteManager: <#AccountDeleteManager#>)
//    }
//}
