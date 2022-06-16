//
//  AuthViewModel.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import SwiftUI
//import Firebase
import Firebase


class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser: Bool = false
    
    private var tempUserSession: FirebaseAuth.User?
    
    init(){
        self.userSession = Auth.auth().currentUser
    }
    
    //MARK: - LOGIN
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if let error = error {
                print("DEBUG: Failed to Signin with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user

        }
    }
    
    //MARK: - Registration
    func register(withEmail email: String, password: String, fullname: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.tempUserSession = user
            
            let data = ["email": email,
                        "username": username.lowercased(),
                        "fullname": fullname,
                        "uid": user.uid]
            
            Firestore.firestore().collection("users").document(user.uid).setData(data) { _ in
                self.didAuthenticateUser = true
            }
            
        }
    }
    
    //MARK: - LOGOUT
    func signOut() {
        // sets user session to nil so we show login view
        userSession = nil
        tempUserSession = nil
        didAuthenticateUser = false
        
        // signs user out on server
        try? Auth.auth().signOut()
        
    }

    
    //MARK: - FETCH USER
    
    
    //MARK: - UPLOAD Profile Image
    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = tempUserSession?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]) { _ in
                    self.userSession = self.tempUserSession
//                    self.fetchUser()
                }
        }
    }

    
    
}
