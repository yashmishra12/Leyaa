//
//  ButtonStyle.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/5/22.
//

import Foundation
import SwiftUI


extension View {

    func buttonStyle() -> some View {
        self.padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .background(Color("MediumBlue"))
            .clipShape(Capsule())
    }
    
    func payTabStyle() -> some View {
        self.padding(.horizontal, 20)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .background(Color("MediumBlue"))
            .clipShape(Capsule())
            .padding(.horizontal, 10)
    }

}
