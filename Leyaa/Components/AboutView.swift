//
//  AboutView.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/23/22.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
       

        VStack {
            Image("leyaaLogo").resizable().aspectRatio(contentMode: .fit).padding()
            
            Text("Leyaa").font(.title).multilineTextAlignment(.center)
            
            Text("v\(appVersion)").padding(.bottom)
            
            Text("Privacy Policy").font(.footnote).foregroundColor(.blue)
                .padding()
                .onTapGesture {
                if let url = URL(string: privacyPolicyURL) {
                    UIApplication.shared.open(url)
                }
            }
            
            
            Text("App Support").font(.footnote).foregroundColor(.blue)
                .onTapGesture {
                if let url = URL(string: appSupportURL) {
                    UIApplication.shared.open(url)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
