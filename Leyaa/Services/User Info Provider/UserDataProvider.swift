//
//  UserDataProvider.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/21/22.
//


import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

@MainActor
class UserDataasdProvider: ObservableObject {
    
    private var db = Firestore.firestore()
    
    @Published var avatarToShow: String = "Ketchup"
    @Published var nameToShow: String = ""
    @Published var emailToShow: String = ""
    
    @Published var userID: String
    
    init(id: String? = nil) {
        if let id = id {
            userID = id
        } else {
            userID = ""
        }
    }
    
    func updateData(id: String) {
        getProfileName(userID: id) { newName in
            self.nameToShow = newName
        }
        
        getProfileAvatar(userID: id) { newAvatar in
            self.avatarToShow = newAvatar
        }
        
        getProfileEmail(userID: id) { newEmail in
            self.emailToShow = newEmail
        }
    }
    
    @MainActor
    func getProfileAvatar(userID: String, completion: @escaping (String) -> Void) {
        var profilePic: String = ""
        let docRef = db.collection("users").document(userID)
        
        
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                        profilePic = document.get("avatar") as? String ?? ""
                        completion(profilePic)
                    
                } else {
                    print("Document does not exist")
                }
            }
        
    }
    
    
    @MainActor
    func getProfileName(userID: String, completion: @escaping (String) -> Void) {
        var profileName: String = ""
        let docRef = db.collection("users").document(userID)
        
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                        profileName = document.get("fullname") as? String ?? ""
                        completion(profileName)
                    
                } else {
                    print("Document does not exist")
                }
            
        }
    }
    
    @MainActor
    func getProfileEmail(userID: String, completion: @escaping (String) -> Void) {
        var profileEmail: String = ""
        let docRef = db.collection("users").document(userID)
        
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
               
                    
                        profileEmail = document.get("email") as? String ?? ""
                        completion(profileEmail)
                    
                    
                } else {
                    print("Document does not exist")
                }
            }
        
    }
    
    @MainActor
    func getDeviceToken(userID: String, completion: @escaping (String) -> Void) {
        var deviceToken: String = ""
        let docRef = db.collection("users").document(userID)
        
        
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
