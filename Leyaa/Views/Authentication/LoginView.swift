//
//  LoginView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI
import FirebaseService
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import Firebase


struct LoginView: View {
    
    private var db = Firestore.firestore()
    
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword: Bool = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State var currentNonce: String?
    
    
     func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
     func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    
    
    var body: some View {
        
        NavigationView {
        
            ZStack {
                
                
                VStack {
                    
                    //MARK: - HEADER
                    VStack{
                        AuthHeaderView(title1: "Hello.", title2: "Welcome Back")
                            .frame(height: screenHeight * 0.25)
                    }
                    
                    //MARK: - FORM
                    VStack(spacing: 40) {
                        
                        CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                        
                        
                        CustomInputField(imageName: "key",
                                         placeholderText: "Password",
                                         isSecureField: true,
                                         text: $password)
                        
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, screenHeight*0.1)
                    .foregroundColor(.white)
                    
                    //MARK: - FORGOT PASSWORD
                    HStack{
                        Spacer()
                        
                        Button {
                            showForgotPassword.toggle()
                        } label: {
                            Text("Forgot Password?").font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal, 32)
                                .padding(.top, 15)
                                .padding(.bottom, 25)
                            
                        }.buttonStyle(.plain)
                            .sheet(isPresented: $showForgotPassword) {
                                    ForgotPasswordView()
                            }

                        
                    }
                    
                    
                    //MARK: - SIGN IN BUTTON
                    VStack{
                        Button {
                            viewModel.login(withEmail: email, password: password)
                        } label: {
                            Text ("Sign In")
                                .font (.headline)
                                .foregroundColor (.white)
                                .frame (width: screenWidth * 0.8, height: 40)
                                .background(Color("MediumBlue"))
                                .clipShape(Capsule())
                                .padding ()
                        }
//                        .shadow(color: .black, radius: 10, x: 0, y: 0)
                        .padding(.top, 10)
                        .buttonStyle(.plain)
                        .alert(isPresented: self.$viewModel.errorOccurred) {
                            Alert(title: Text("Invalid Credentials"), message: Text(self.viewModel.errorMessage), dismissButton: .default(Text("Ok")))
                        }
                    }
                    
 
                    
                    //MARK: - Sign In with Apple
                    
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
                                            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                                return
                                            }

                                            let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString, rawNonce: nonce)

                                            Auth.auth().signIn(with: credential) { (authResult, error) in
                                                if (error != nil) {
                                                    print(error?.localizedDescription as Any)
                                                    return
                                                }
                                                guard let user = authResult?.user else {return}
                                                self.viewModel.userSession = user

                                                
                                                let docRef = self.db.collection("users").document(user.uid)
                                                
                                                docRef.getDocument { document, error in
                                                    if let document = document {
                                                        if document.exists {
                                                            self.viewModel.appleLogin()
                                                            
                                                        } else {
                                                            let changeRequest = authResult?.user.createProfileChangeRequest()
                                                            changeRequest?.displayName = (appleIDCredential.fullName?.givenName ?? "") + " " +                                 (appleIDCredential.fullName?.familyName ?? "")
                                                            
                                                            
                                                            changeRequest?.commitChanges(completion: { (error) in
                                                                let data = ["email": user.email ?? "",
                                                                            "avatar": assetName.randomElement() ?? "egg",
                                                                            "fullname": Auth.auth().currentUser?.displayName ?? "",
                                                                            "uid": user.uid] as [String : Any]
                                                                
                                                                Firestore.firestore().collection("users").document(user.uid).setData(data) { _ in
                                                                    self.viewModel.didAuthenticateUser = true
                                                                }
                                                                
                                                                self.viewModel.appleLogin()
                                                            })
                                                        }
                                                    }
                                                }
                                                
                                          
                                                
                                             


                                            }

                                            print("\(String(describing: Auth.auth().currentUser?.uid))")
                                        default:
                                            break

                                        }
                                    default:
                                        break
                                    }
                                }
                            ).buttonStyle(.plain)
                        }.frame(width:  screenWidth * 0.8, height: 40)
                            .clipShape(Capsule())
                            .padding(.horizontal, 32)
                            .padding(.top, 15)

                    }
                    
                
                    
                    
                    Spacer()
                    
                    
                    
                    //MARK: - SIGN UP
                    
                    
                    NavigationLink(destination: RegistrationView() ) {
                        HStack{
                            Text("Don't have an account?")
                                .font (.footnote)
                                .foregroundColor(Color.white)
                            
                            Text("Sign Up")
                                .font (.callout)
                                .fontWeight (.semibold)
                                .foregroundColor(Color("LightBlue"))
                        }
                        
                    }.buttonStyle(.plain)
                    
                }.background(Color("DarkBlue"))
                
            }
                .navigationBarHidden(true)
                
        }.navigationBarBackButtonHidden(true)
           
    }
 

}






struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
        
    }
}
