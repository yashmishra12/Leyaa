//
//  LoginView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
            
        NavigationView {
            ZStack {
                    
                    VStack{
                        
                        //MARK: - HEADER
                        VStack{
                            AuthHeaderView(title1: "Hello.", title2: "Welcome Back")
                            .frame(height: 260)
                            .padding(.leading)
                            .background(Color("MediumBlue"))
                            .clipShape(RoundedShape(corners: [.bottomRight]))
                            .ignoresSafeArea()
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
                        .padding(.top, 40)
                        .foregroundColor(.white)
                        
                        //MARK: - FORGOT PASSWORD
                        HStack{
                            Spacer().background(Color("DarkBlue"))
                            
                            NavigationLink {
                                Text("Reset Password View")
                            } label: {
                                Text("Forgot Password?")
                                    .fontWeight(.light)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.trailing)
                                    .padding(25)

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
                                    .frame (width: 340, height: 50)
                                    .background(Color("MediumBlue"))
                                    .clipShape(Capsule())
                                    .padding ()
                            }
                            .shadow(color: .black, radius: 10, x: 0, y: 0)
                            .padding(.top, 25)
                            .buttonStyle(.plain)
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
                            

                        }.padding(.bottom, 50)
                        
                    }.ignoresSafeArea()
                .navigationBarHidden(true)
            .background(Color("DarkBlue"))
        }
        
                
            }
            
        
            
    }

    struct ItemPhotoModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .frame(width: 100, height: 100)
                .padding(1)
        }
    }





struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            
    }
}
