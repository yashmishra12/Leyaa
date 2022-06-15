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
    
    var body: some View {
        
        ZStack {
            Color("DarkBlue").ignoresSafeArea()
            
            
            VStack {
                
                //MARK: - HEADER
                VStack {
                    AuthHeaderView(title1: "Get Started.", title2: "Create an account")
                }
                
                //MARK: - SIGNUP
                VStack(spacing: 40){
                    CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                    CustomInputField(imageName: "person.wave.2", placeholderText: "Full Name", text: $fullname)
                    CustomInputField(imageName: "person", placeholderText: "Username", text: $username)
                    CustomInputField(imageName: "key", placeholderText: "Password", text: $password)
                    
                }
                .padding(.horizontal, 32)
                .padding(.top, 40)
                .foregroundColor(.white)
                
                //MARK: - SIGN IN BUTTON
                VStack{
                    Button {
                        print("Sign in here..")
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
                        }.padding(.bottom, 30)
                }

                
                
                
            }
            .ignoresSafeArea()
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
