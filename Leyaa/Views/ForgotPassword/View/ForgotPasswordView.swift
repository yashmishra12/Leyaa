//
//  ForgotPasswordView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/30/22.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = ForgotPasswordViewModelImpl(
        service: ForgotPasswordServiceImpl()
    )
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill").resizable().frame(width: 20, height: 20)
                    }.frame(width: 25, height: 25)

                }.padding()
                Spacer()
            }
            
            VStack {
                Image("forgotPassword").resizable().aspectRatio(contentMode: .fit).padding(.top, -100).padding(.bottom, 50)
                VStack(spacing: 16) {
                    
                        CustomInputField(imageName: "envelope", placeholderText: "Reset link will be sent here.", isSecureField: false, text: $viewModel.email).padding()
                        
                        Button {
                            viewModel.sendPasswordResetRequest()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Send Reset Request").buttonStyle()
                        }.disabled(isValidEmail($viewModel.email.wrappedValue)==false)
                        .buttonStyle(.plain)
            

                        
                    }
                    .padding(.horizontal, 15)
                .navigationTitle("Reset Password")
            }
        }
       

    }
    
    
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
