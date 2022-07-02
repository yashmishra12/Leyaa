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
        VStack {
            Image("forgotPassword").resizable().frame(width: 300, height: 300).padding(.top, -100).padding(.bottom, 50)
            VStack(spacing: 16) {
                
                    CustomInputField(imageName: "envelope", placeholderText: "Reset link will be sent here.", isSecureField: false, text: $viewModel.email).padding()
                    
                    Button {
                        viewModel.sendPasswordResetRequest()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Send Reset Request")
                            .font (.headline)
                                .foregroundColor (.white)
                                .frame (width: screenWidth * 0.60, height: 40)
                                .background(Color("MediumBlue"))
                                .clipShape(Capsule())
                                .padding ()
                    }.disabled(isValidEmail($viewModel.email.wrappedValue)==false)
                    .buttonStyle(.plain)
        

                    
                }
                .padding(.horizontal, 15)
            .navigationTitle("Reset Password")
        }

    }
    
    
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
