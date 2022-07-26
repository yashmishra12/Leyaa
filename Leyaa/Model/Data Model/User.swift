//
//  User.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var fullname: String
    var email: String
    var avatar: String
    var deviceToken: String
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
}

