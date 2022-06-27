//
//  SideMenuHeaderView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/27/22.
//

import SwiftUI

struct SideMenuHeaderView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack(alignment: .topTrailing) {
            let name = viewModel.currentUser?.fullname
            let email = viewModel.currentUser?.email
            
            VStack(alignment: .leading) {
               
                HStack {
                    VStack{
                        AsyncImage(url: URL(string: viewModel.currentUser?.profileImageUrl ?? "")!) {
                            Image(systemName: "person")
                        } image: { image in
                            Image(uiImage: image).resizable()
                            
                        }.aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(width: 64, height: 64).clipShape(Circle())
                            .padding(.bottom, 16)
                    }
                    VStack{
                        HStack {
                            Text(name  ?? "").font(.system(size: 24, weight: .semibold))
                            Spacer()
                        }
                        
                        
                        HStack {
                            Text(email ?? "").font(.system(size: 14))
                            Spacer()
                        }
                    }
                }

                
                Spacer()
            }
            .padding()
        }
    }
}

struct SideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeaderView(isShowing: .constant(true)).previewLayout(.sizeThatFits)
    }
}
