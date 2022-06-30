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
            VStack(spacing: 16) {
            
                CustomInputField(imageName: "envelope", placeholderText: "Email to receive reset link", isSecureField: false, text: $viewModel.email)
                
                Button {
                    viewModel.sendPasswordResetRequest()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Send Reset Request")
                }
    

                
            }
            .padding(.horizontal, 15)
            .navigationTitle("Reset Password")

    }
    
    
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

