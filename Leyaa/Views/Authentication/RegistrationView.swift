//
//  RegistrationView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                NavigationLink(destination: ContentView(),
                               isActive: $viewModel.didAuthenticateUser,
                               label: { })


                
                //MARK: - HEADER
                VStack {
                    AuthHeaderView(title1: "Get Started.", title2: "Create an account")
                        .frame(height: screenHeight * 0.25)
                }
                
                Spacer()
                
                //MARK: - SIGNUP
                VStack(spacing: 40){
                    CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                    CustomInputField(imageName: "person", placeholderText: "Full Name", text: $fullname)
                    CustomInputField(imageName: "key", placeholderText: "Password", isSecureField: true, text: $password)
                    
                    
                }
                .padding(.horizontal, 32)
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
                            .frame (width: screenWidth * 0.8, height: 40)
                            .background(Color("MediumBlue"))
                            .clipShape(Capsule())
                            .padding ()
                    }
                    .padding(.top, 10)
                    .buttonStyle(.plain)
                    .alert(isPresented: self.$viewModel.errorOccurred) {
                        Alert(title: Text("Invalid Credentials"), message: Text(self.viewModel.errorMessage), dismissButton: .default(Text("Ok")))
                    }
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
                    .buttonStyle(.plain)

            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }.background(Color("DarkBlue"))
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(AuthViewModel())
    }
}


