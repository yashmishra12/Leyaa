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
                
                Button {
                    let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
                    ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { state, error in
                        guard error != nil else {
                        print("Error on getting user's credential.")
                        return
                      }
                      switch state {
                      case .authorized:
                        print("User has authorized and app can run smoothly.")
                      case .revoked:
                          self.isRevoked = true
                          print("REVOKED WORKING FROM USER DEFAULT --> \(userID)")
                      case .notFound, .transferred:
                       print("There is a problem on the user's authorization. Action has to be taken")
                      @unknown default:
                          print("Unknown Dfault")
                      }
                    }
                } label: {
                    Text("Hit Me")
                }.buttonStyle(.plain)
                    .buttonStyle()
                
                NavigationLink {
                    DeleteAccountData()
                } label: {
                    Text("Next").padding(.vertical, -2)
                }.buttonStyle()
                    .buttonStyle(.plain)
                    .disabled(accountDeleteManager.isAppleAuthRevoked == false)
               
            }
            .onAppear {
                let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
                ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { state, error in
                    guard error != nil else {
                    print("Error on getting user's credential.")
                    return
                  }
                  switch state {
                  case .authorized:
                    print("User has authorized and app can run smoothly.")
                  case .revoked:
                      self.isRevoked = true
                      print("REVOKED WORKING FROM USER DEFAULT --> \(userID)")
                  case .notFound, .transferred:
                   print("There is a problem on the user's authorization. Action has to be taken")
                  @unknown default:
                      print("Unknown Dfault")
                  }
                }
            }
       
    }
}

//struct RevokeInstruction_Previews: PreviewProvider {
//    static var previews: some View {
//        RevokeInstruction(, accountDeleteManager: <#AccountDeleteManager#>)
//    }
//}
