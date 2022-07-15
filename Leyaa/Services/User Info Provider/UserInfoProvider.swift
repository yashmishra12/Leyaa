//
//  UserInfoProvider.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/15/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class UserInfoProvider {
    
    private var db = Firestore.firestore()
    
    func getProfileAvatar(userID: String, completion: @escaping (String) -> Void) {
        var profilePic: String = ""
        let docRef = db.collection("users").document(userID)
        
        
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    DispatchQueue.main.async {
                        profilePic = document.get("avatar") as? String ?? ""
                        completion(profilePic)
                    }
                } else {
                    print("Document does not exist")
                }
            }
        
    }
    
    
    func getProfileName(userID: String, completion: @escaping (String) -> Void) {
        var profileName: String = ""
        let docRef = db.collection("users").document(userID)
        
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    DispatchQueue.main.async {
                        profileName = document.get("fullname") as? String ?? ""
                        completion(profileName)
                    }
                } else {
                    print("Document does not exist")
                }
            
        }
    }
    
    
    func getProfileEmail(userID: String, completion: @escaping (String) -> Void) {
        var profileEmail: String = ""
        let docRef = db.collection("users").document(userID)
        
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
               
                    DispatchQueue.main.async {
                        profileEmail = document.get("email") as? String ?? ""
                        completion(profileEmail)
                    }
                    
                } else {
                    print("Document does not exist")
                }
            }
        
    }
    
    
    func getDeviceToken(userID: String, completion: @escaping (String) -> Void) {
        var deviceToken: String = ""
        let docRef = db.collection("users").document(userID)
        
        DispatchQueue.main.async {
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    deviceToken = document.get("deviceToken") as! String
                    completion(deviceToken)
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
}
