//
//  UserService.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/25/22.
//

import Foundation
import Firebase
import FirebaseService

struct UserService {
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                
                guard let user = try? snapshot.data(as: User.self) else { return }
                completion(user)
            }
    }
    
    func assignUsingClosure( x: String, completion: @escaping(String)-> Void) {
        completion(x)
    }
    
}
