//
//  CreateButtonView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import SwiftUI

struct CreateButtonView: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Text("Start")
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Capsule().strokeBorder(Color.white, lineWidth: 1.25))
        } //: BUTTON
        .accentColor(Color.white)
    }
}

struct CreateButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CreateButtonView()
    }
}
