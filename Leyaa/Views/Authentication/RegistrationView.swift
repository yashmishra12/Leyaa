//
//  RegistrationView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI
import Focuser
import UIKit




struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    @FocusState private var emailFocus: Bool
    @FocusState private var nameFocus: Bool
    @FocusState private var passFocus: Bool
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                NavigationLink(destination: ContentView(),
                               isActive: $viewModel.didAuthenticateUser,
                               label: { })


                
                //MARK: - HEADER
                VStack {
                    AuthHeaderView(title1: "Get Started.").padding(.top)
                }

        
                
                //MARK: - SIGNUP
                VStack(spacing: 40){
                    CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                        .focused($nameFocus)
                        .onSubmit {
                            nameFocus = true
                        }
                        .submitLabel(.next)
                        
                    
                    CustomInputField(imageName: "person", placeholderText: "Full Name", text: $fullname)
                        .focused($nameFocus)
                        .onSubmit {
                            passFocus = true
                        }
                        .submitLabel(.next)
                    
                    CustomInputField(imageName: "key", placeholderText: "Password", isSecureField: true, text: $password)
                        .focused($passFocus)
                        .onSubmit {
                            passFocus = false
                        }
                        .submitLabel(.done)
                    
                    
                }
                .padding(.horizontal, 32)
                .padding(.top)
                
                //MARK: - SIGN UP BUTTON
                VStack{
                    Button {
                        viewModel.register(withEmail: email,
                                           password: password,
                                           fullname: fullname)
                    } label: {
                        Text ("Sign Up").buttonStyle()
                    }.disabled(isValidEmail(email)==false)
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

                            
                            Text("Sign In")
                                .font (.callout)
                                .fontWeight (.semibold)
                                .foregroundColor(Color("MediumBlue"))
                            }
                    }
                }.padding(.bottom, 30)
                    .buttonStyle(.plain)

            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }.onTapGesture {
            self.endTextEditing()
        }

    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(AuthViewModel())
    }
}



extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}
