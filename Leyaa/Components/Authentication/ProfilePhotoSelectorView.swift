//
//  ProfilePhotoSelectorView.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import SwiftUI

struct ProfilePhotoSelectorView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                AuthHeaderView(title1: "Photo.", title2: "Add a Profile Photo.")
               
     
                //MARK: - PROFILE IMAGE BUTTON
                VStack{
                    Button {
                        showImagePicker.toggle()
                    } label: {
                        if let profileImage = profileImage {
                            profileImage
                                .resizable()
                                .modifier(ProfileImageModifier())
                        } else {
                            Image(systemName: "photo.circle")
                                .resizable()
                                .renderingMode(.template)
                                .modifier(ProfileImageModifier())
                        }
                    }
    //                .buttonStyle(.plain)
                    .padding(.top, 100)
                    .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                }

                if let selectedImage = selectedImage {
                        Button {
                            viewModel.uploadProfileImage(selectedImage)
                        } label: {
                            Text ("Save")
                                .font (.headline)
                                .foregroundColor (.white)
                                .frame (width: 340, height: 50)
                                .background(Color("MediumBlue"))
                                .clipShape(Capsule())
                                .padding ()
                        }
                        .shadow(color: .black, radius: 15, x: 0, y: 0)
                        .padding(.top, 25)
    //                    .buttonStyle(.plain)
                    
                }
            
                Spacer()
                
            }
            .ignoresSafeArea()
        }

    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else {return}
        profileImage = Image(uiImage: selectedImage)
    }
}

private struct ProfileImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(.systemBlue))
            .scaledToFill()
            .frame(width: 180, height: 180)
            .clipShape(Circle())
//            .buttonStyle(.plain)
    }
}


struct ProfilePhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoSelectorView()
    }
}

