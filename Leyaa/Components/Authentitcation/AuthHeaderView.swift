//
//  AuthHeader.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/14/22.
//

import SwiftUI

struct AuthHeaderView: View {
    let title1: String
    let title2: String
    
    var body: some View {
        //MARK: - HEADER
        VStack (alignment: .leading) {
            HStack(){Spacer()}
            Text(title1)
                .fontWeight(.semibold)
                .font(.largeTitle)
                .foregroundColor(.white)
            
            
            Text(title2)
                .fontWeight(.semibold)
                .font(.largeTitle)
                .foregroundColor(.white)
        }
        .frame(height: 260)
        .padding(.leading)
        .background(Color("MediumBlue"))
        .clipShape(RoundedShape(corners: [.bottomRight]))
        .ignoresSafeArea()
    }
}

struct AuthHeader_Previews: PreviewProvider {
    static var previews: some View {
        AuthHeaderView(title1: "Title1", title2: "Title2")
    }
}
