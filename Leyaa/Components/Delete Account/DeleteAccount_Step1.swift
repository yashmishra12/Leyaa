//
//  DeleteAccount_Step1.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/17/22.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import Firebase


struct DeleteAccount_Step1: View {
    @State var currentNonce: String?
    @EnvironmentObject var viewModel: AuthViewModel
    @State var goToInstructionPage: Bool = false
    
    @StateObject var accountDeleteManager = AccountDeleteManager()
    
    var body: some View {
        VStack {
            Text("How did you create your account? ").font(.title2)
                .padding()
            
            
            VStack {
                SignInWithAppleButton(
                    onRequest: { request in
                        let nonce = randomNonceString()
                        currentNonce = nonce

                        request.requestedScopes = [.fullName, .email]
                        request.nonce = sha256(nonce)
                    },
                    onCompletion: { result in
                        switch result {
                        
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:

                                guard let nonce = currentNonce else {
                                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                }
                                
                                guard let appleIDToken = appleIDCredential.identityToken else {
                                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                }
                                
                                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                    return
                                }



                                NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
                                object: nil,
                               queue: .main,
                                using: { notification in
                                    print("----------------------REVOKED: Delete Account Step 1----------------------")
                                    viewModel.revoked()
                                    accountDeleteManager.revoked()
                                })
                                
                     

                                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                          idToken: idTokenString,
                                                                          rawNonce: nonce)

                                Auth.auth().signIn(with: credential) { (authResult, error) in
                                    if (error != nil) {
                                        print(error?.localizedDescription as Any)
                                        return
                                    }
                                    
                                    self.goToInstructionPage = true
                                                                
                                }

                            default:
                                break

                            }
                        default:
                            break
                        }
                    }
                )
                .appleBorder(.black, width: 1, cornerRadius: 25)
                .signInWithAppleButtonStyle(.white)
                .clipShape(Capsule())


            }.frame(width:  screenWidth * 0.8, height: 40)
                .padding(.horizontal, 32)
                .padding(.top, 35)


            

            NavigationLink(destination: RevokeInstruction(accountDeleteManager: accountDeleteManager),
                           isActive: $goToInstructionPage,
                           label: { })
            .buttonStyle(.plain)
           
            
//
//            NavigationLink {
//                ActivateObserver()
//            } label: {
//                Text("With Apple Sign-In")
//            }.buttonStyle()
//                .buttonStyle(.plain)
//                .padding()
//
            
            
            NavigationLink {
                DeleteAccountData()
            } label: {
                Text("Normal Sign-Up")
            }.buttonStyle()
                .buttonStyle(.plain)
                .padding()

        }
    }
}

struct DeleteAccount_Step1_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccount_Step1()
    }
}
