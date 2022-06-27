//
//  User.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import FirebaseFirestoreSwift
import Firebase
import UIKit

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let fullname: String
    let profileImageUrl: String
    let email: String
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
}


//AsyncImage(
//  url: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/leyaa-7b042.appspot.com/o/profile_image%2FF1D826A4-0955-423F-8783-6693E670DF5A?alt=media&token=0dfbd1e8-228b-446f-b224-9c205681da72"),
//  content: { image in
//  image
//    .resizable()
//    .aspectRatio(contentMode: .fit)
//}, placeholder: {
//  Color.gray
//})
//  .frame(width: 100, height: 100)
//  .mask(RoundedRectangle(cornerRadius: 16))
