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
    let email: String
    let avatar: String
    let deviceToken: String
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
}

