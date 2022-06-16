//
//  ItemPhotoModifier.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import SwiftUI

struct ItemPhotoModifier: View {
    struct ItemPhotoModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .foregroundColor(Color(.systemBlue))
                .scaledToFill()
                .frame(width: 180, height: 180)
                .clipShape(Circle())
        }
    }
}

struct ItemPhotoModifier_Previews: PreviewProvider {
    static var previews: some View {
        ItemPhotoModifier()
    }
}
