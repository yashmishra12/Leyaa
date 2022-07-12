
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

    @FocusState private var emailFocus: Bool
    @FocusState private var passFocus: Bool
    
    var body: some View {
        
        NavigationView {
        
            ZStack {
                
                
                VStack {
                    
                    //MARK: - HEADER
                    VStack{
                        AuthHeaderView(title1: "Hello There")
                            .padding(.top)
                    }.onTapGesture {
                        self.endTextEditing()
                    }
                    
                    //MARK: - FORM
                    VStack(spacing: 40) {
                        
                        CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                            .focused($emailFocus)
                            .onSubmit {
                                passFocus = true
                            }
                            .submitLabel(.next)
                            
                        
                        
                        CustomInputField(imageName: "key",
                                         placeholderText: "Password",
                                         isSecureField: true,
                                         text: $password)
                        .focused($passFocus)
                        .onSubmit {
                            passFocus = false
                        }
                        .submitLabel(.done)
                        
                    }
                    .onTapGesture {
                        self.endTextEditing()
                    }
                    .padding(.horizontal, 32)
                    .padding(.top)

                    
                    //MARK: - FORGOT PASSWORD
                    HStack{
                        Spacer()
                        
                        Button {
                            showForgotPassword.toggle()
                        } label: {
                            Text("Forgot Password?").font(.caption)
                                .fontWeight(.light)
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal, 32)
                                .padding(.top, 15)
                                .padding(.bottom, 25)
                                
                            
                        }.buttonStyle(.plain)
                            .sheet(isPresented: $showForgotPassword) {
                                    ForgotPasswordView()
                            }

                        
                    }.onTapGesture {
                        self.endTextEditing()
                    }
                    
                    
                    //MARK: - SIGN IN BUTTON
                    VStack{
                        Button {
                            viewModel.login(withEmail: email, password: password)
                        } label: {
                            Text ("Sign In").buttonStyle()
                        }.disabled(isValidEmail(email)==false)
                            .buttonStyle(.plain)

                        .padding(.top, 10)
                        .buttonStyle(.plain)
                        .alert(isPresented: self.$viewModel.errorOccurred) {
                            Alert(title: Text("Invalid Credentials"), message: Text(self.viewModel.errorMessage), dismissButton: .default(Text("Ok")))
                        }
                    }.onTapGesture {
                        self.endTextEditing()
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
                                                                            "avatar": assetName.randomElement()?.sanitiseItemName() ?? "egg",
                                                                            "fullname": Auth.auth().currentUser?.displayName ?? "",
                                                                            "deviceToken": UserDefaults.standard.string(forKey: "kDeviceToken") ?? "",
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
                    
                
                    
                    
                    Spacer()
                    
                    
                    
                    //MARK: - SIGN UP
                    
                    VStack {
                        NavigationLink(destination: RegistrationView().hideKeyboardWhenTappedAround() ) {
                            HStack{
                                Text("Don't have an account?")
                                    .font (.footnote)
            
                                
                                Text("Sign Up")
                                    .font (.callout)
                                    .fontWeight (.semibold)
                                    .foregroundColor(Color("MediumBlue"))
                            }
                            
                        }.buttonStyle(.plain)
                    }.padding(.bottom, 30)
                    
                    
                    
                }
                .ignoresSafeArea()

                
            }
                .navigationBarHidden(true)
                
        }
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
           
    }
 

}

extension View {
    func appleBorder(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
        
    }
}
