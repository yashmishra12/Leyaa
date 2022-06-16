//
//  CustomInputField.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI

struct CustomInputField: View {
    let imageName: String
    let placeholderText: String
    var isSecureField: Bool? = false
    
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack{
                Image (systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame (width: 20, height: 20)
                    .foregroundColor (Color("LightBlue"))
                    .padding(.trailing, 15)
                
                if isSecureField ?? false {
                    SecureField(placeholderText, text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    TextField(placeholderText, text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                 
                
                
                
            }
            Divider()
                .background(Color("LightBlue"))
        }
    }
}

struct CustomInputField_Previews: PreviewProvider {
    static var previews: some View {
        
        CustomInputField (imageName: "envelope",
                         placeholderText: "Email",
                         isSecureField: false,
                         text: .constant(""))
            .preferredColorScheme(.dark)
    }
}
