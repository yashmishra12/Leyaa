//
//  ActivateObserver.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/17/22.
//

import SwiftUI

struct ActivateObserver: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var checked: Bool = false
    var body: some View {
        VStack {
            Text("Sign-Out, Login with Apple and Come Back here.").font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("NOTE: Do not close the app by swiping up after login").font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
            
            Toggle(isOn: $checked) {
                Text("I have logged back in without closing the app by swiping up.").font(.footnote)
            }.toggleStyle(.switch)
                .padding()
                
            
            
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Sign Out")
                }.buttonStyle()
                    .buttonStyle(.plain)
                    .padding()

            
            
//            NavigationLink {
//                RevokeInstruction()
//
//            } label: {
//                Text("Next")
//            }.buttonStyle()
//                .buttonStyle(.plain)
//                .disabled(checked == false)
//                .padding()
        }
    }
}

struct ActivateObserver_Previews: PreviewProvider {
    static var previews: some View {
        ActivateObserver()
    }
}
