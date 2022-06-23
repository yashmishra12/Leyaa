//
//  RegistrationView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
    
                
                NavigationLink(destination: ProfilePhotoSelectorView(),
                               isActive: $viewModel.didAuthenticateUser,
                               label: { })
                
                
                
                //MARK: - HEADER
                VStack {
                    
                    AuthHeaderView(title1: "Get Started.", title2: "Create an account")
                }
                
                
                
                //MARK: - SIGNUP
                VStack(spacing: 40){
                    CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                    CustomInputField(imageName: "person", placeholderText: "Full Name", text: $fullname)
                    CustomInputField(imageName: "key", placeholderText: "Password", isSecureField: true, text: $password)
                    
                    
                }
                .padding(.horizontal, 32)
                .padding(.top, 40)
                .foregroundColor(.white)
                
                //MARK: - SIGN UP BUTTON
                VStack{
                    Button {
                        viewModel.register(withEmail: email,
                                           password: password,
                                           fullname: fullname)
                    } label: {
                        Text ("Sign Up")
                            .font (.headline)
                            .foregroundColor (.white)
                            .frame (width: 340, height: 50)
                            .background(Color("MediumBlue"))
                            .clipShape(Capsule())
                            .padding ()
                    }
                    .shadow(color: .black, radius: 15, x: 0, y: 0)
                    .padding(.top, 25)
                }
                
                Spacer()
                
                //MARK: - SIGN IN MESSAGE
                VStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack{
                            Text("Have an account?")
                                .font (.footnote)
                                .foregroundColor(Color.white)
                            
                            Text("Sign In")
                                .font (.callout)
                                .fontWeight (.semibold)
                                .foregroundColor(Color("LightBlue"))
                            }
                    }
                }.padding(.bottom, 30)

                
                
                
            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }.background(Color("DarkBlue"))
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
