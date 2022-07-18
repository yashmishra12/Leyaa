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
                                    
                                    print("USER ID----> \(appleIDCredential.user)")
                                    UserDefaults.standard.set(appleIDCredential.user, forKey: "userID")

                                    
                                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                        return
                                    }
                                    
                                    // Add new code below
                                    if let authorizationCode = appleIDCredential.authorizationCode,
                                       let codeString = String(data: authorizationCode, encoding: .utf8) {


                                          let url = URL(string: "https://us-central1-leyaa-7b042.cloudfunctions.net/getRefreshToken?code=\(codeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!

                                            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

                                                if let data = data {
                                                    let refreshToken = String(data: data, encoding: .utf8) ?? ""
                                                    print("Refresh Token while Login: \(refreshToken)")
                                                    UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                                                    UserDefaults.standard.synchronize()
                                                }
                                            }
                                          task.resume()

                                      }


                                    
                                    let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString, rawNonce: nonce)

                                    Auth.auth().signIn(with: credential) { (authResult, error) in
                                        if (error != nil) {
                                            print(error?.localizedDescription as Any)
                                            return
                                        }

                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            viewModel.removeAccount()
                                        }
                                        
                                        goToInstructionPage = true
                                        
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

            }
            
    
                    
            
            NavigationLink {
                DeleteAccountData()
            } label: {
                Text("Normal Sign-Up")
            }.buttonStyle()
                .buttonStyle(.plain)
                .padding()
            
            
            NavigationLink(destination: DeleteAccountData(),
                           isActive: $goToInstructionPage,
                           label: { }).buttonStyle(.plain)
            
        
    }
}
                    }

struct DeleteAccount_Step1_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccount_Step1()
    }
}

                    
