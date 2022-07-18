
//
//  AuthViewModel.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseService
import AuthenticationServices

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser: Bool = false
    @Published var rooms = [Room]()
    @Published var pendingReqest = [RoomRequest]()
    @Published var currentUser: User?
    

    
    
    @Published var isAppleAuthRevoked: Bool = false
    
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String = ""
    
    private var db = Firestore.firestore()
    
    private let service = UserService()
    
    
    @Published private(set) var messagesToDelete: [Message] = []
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    
    func revoked() {
        DispatchQueue.main.async {
            self.isAppleAuthRevoked = true
        }
    }
    
    //MARK: - Authenticate with Apple
    
    func appleLogin() {
        self.didAuthenticateUser = true
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
        self.writeUserData()
    }
    
    
    
    //MARK: - Maintains a fresh copy of Device Token
    func writeUserData() {
        if self.currentUser == nil { return }
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData(["deviceToken": UserDefaults.standard.string(forKey: deviceTokenStorage) ?? "" ]){ error in
            if let error = error {
                print("WRITE USER DATA ERROR Error updating document: \(error)")
            } else {
            }
        }
    }
    
    
    func resetDeviceToken() {
        if self.currentUser == nil {return}
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData(["deviceToken": "" ]){ error in
            if let error = error {
                print("Reset DeviceToken Error: \(error)")
            } else {
            }
        }
    }
    
    //MARK: - Authentication
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if let error = error {
                self.hapticFeedback.notificationOccurred(.error)
                
                self.errorMessage = "\(error.localizedDescription)"
                self.errorOccurred.toggle()
                
                print("DEBUG: Failed to Signin with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
            self.writeUserData()
        }
        
        
    }
    
    
    func register(withEmail email: String, password: String, fullname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.hapticFeedback.notificationOccurred(.error)
                self.errorMessage = "\(error.localizedDescription)"
                self.errorOccurred.toggle()
                
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            
            
            let userData = ["email": email,
                            "deviceToken": UserDefaults.standard.string(forKey: deviceTokenStorage) ?? "",
                            "avatar": assetName.randomElement()?.sanitiseItemName() ?? "egg",
                            "fullname": fullname,
                            "uid": user.uid] as [String : Any]
            
            
            self.db.collection("users").document(user.uid).setData(userData) { _ in
                self.didAuthenticateUser = true
                self.fetchUser()
                self.writeUserData()
            }
            
        }
    }
    
    
    func signOut() {
        // sets user session to nil so we show login view
        userSession = nil
        didAuthenticateUser = false
        
        resetDeviceToken()
        
        // signs user out on server
        try? Auth.auth().signOut()
        
    }
    
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
            self.writeUserData()
        }
    }
    
    
    func nameChange(newName: String) {
        db.collection("users").document(currentUser?.id ?? "").updateData(["fullname" : newName]) {err in
            if let err = err {
                print("Error in name change: \(err)")
            }
        }
        currentUser?.fullname = newName
    }
    
    
    
    
    //MARK: - ROOMS
    
    func addRoom(room: Room) {
        do {
            
            let _ = try db.collection("rooms").addDocument(from: room)
            self.writeUserData()
            
        }
        catch {
            print(error)
        }
    }
    
    
    func populateRoomList () {
        
      self.db.collection("rooms")
            .whereField("members", arrayContains: self.userSession?.uid as Any)
            .addSnapshotListener { snapshot, error in
                
                guard let doc = snapshot?.documents else {
                    print("No Doc Found - Populate Room List")
                    return
                }
                
                self.rooms = doc.compactMap { queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: Room.self) }
                    
                    switch result {
                    case .success(let room):
                        return room
                        
                    case .failure( _):
                        print("Failure Room Populate")
                        return nil
                    }
                }
                
            }
    }
    
    
    func leaveRoom(roomData: Room) {
        let docRef =  db.collection("rooms").document(roomData.id ?? "")
        
        docRef.updateData([
            "members" : FieldValue.arrayRemove([userSession?.uid ?? ""])
        ]){ err in
            if let err = err {
                print("Error in leaving room: \(err)")
            }
        }
        
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let property = document.get("members") as! [String]
                if property.count == 0 {
                    self.db.collection("rooms").document(roomData.id ?? "").delete()
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func roomJoinRequestUpdate() {
        self.db.collection("roomRequest")
            .whereField("receiverEmail", isEqualTo: self.userSession?.email as Any)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    
                    guard let doc = snapshot?.documents else {
                        print("No Doc Found - Room Join Request")
                        return
                    }
                    
                    self.pendingReqest = doc.compactMap { queryDocumentSnapshot in
                        let result = Result { try queryDocumentSnapshot.data(as: RoomRequest.self) }
                        
                        switch result {
                        case .success(let room):
                            return room
                            
                        case .failure( _):
                            print("Failure Room Join Request")
                            return nil
                        }
                    }
                }
            }
    }
    
    
    func roomInvite(recieverEmail: String, message: String, roomData: Room) {
        
        let req = RoomRequest(message: message,
                              roomID: roomData.id ?? "",
                              roomName: roomData.title ,
                              senderName: currentUser?.fullname ?? "",
                              receiverEmail: recieverEmail)
        
        
        do {
            let _ = try db.collection("roomRequest").addDocument(from: req)
        }
        catch {
            print(error)
        }
        
        
    }
    
    
    func rejectRoomRequest(reqData: RoomRequest) {
        
        self.db.collection("roomRequest").document(reqData.id ?? "").delete() { err in
            if let err = err {
                print("Error in adding item: \(err)")
            }
        }
    }
    
    
    func acceptRoomRequest(reqData: RoomRequest) {
        let userToAdd: [String] = [currentUser?.id ?? ""]
        let tokenToAdd: [String] = [UserDefaults.standard.string(forKey: deviceTokenStorage) ?? ""]
        
        self.db.collection("rooms").document(reqData.roomID)
            .updateData(["members" : Firebase.FieldValue.arrayUnion(userToAdd)]){ err in
                if let err = err {
                    print("Error in adding item: \(err)")
                }
            }
        
        self.db.collection("rooms").document(reqData.roomID)
            .updateData(["deviceTokens" : Firebase.FieldValue.arrayUnion(tokenToAdd)]){ err in
                if let err = err {
                    print("Error in adding item: \(err)")
                }
            }
        
        rejectRoomRequest(reqData: reqData)
    }
    
    
    func editRoomName(newName: String,  roomID: String) {
        DispatchQueue.main.async {
            self.db.collection("rooms").document(roomID).updateData(["title" : newName]) { err in
                if let err = err {
                    print("Error in editing room name: \(err)")
                }
            }
        }
    }
    
    
    //MARK: -  Get Profile Info
    
    
    func updateAvatar(userID: String, newAvatar: String) {
        db.collection("users").document(userID).setData([
            "deviceToken": UserDefaults.standard.string(forKey: deviceTokenStorage) ?? "",
            "avatar" :  newAvatar,
            "email": currentUser?.email ?? "",
            "fullname": currentUser?.fullname  ?? "",
            "uid": currentUser?.id  ?? ""]) { err in
                if let err = err {
                    print("Error in adding item: \(err)")
                }
            }
        
        fetchUser()
        
    }
    
    
    //MARK: - Populate UserInfo
    
    func populateUserInfo (memberID: [String]) -> [[String]] {
        return [[""]]
    }
    
    
    
    //MARK: - Account Deactivation
    
    func removeAccount() {
        let token = UserDefaults.standard.string(forKey: "refreshToken")
        
        if let token = token {
            
            let url = URL(string: "https://us-central1-leyaa-7b042.cloudfunctions.net/revokeToken?refresh_token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
            
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard data != nil else { return }
            }
            
            task.resume()
            
        }
        
    }
    
    
    func deleteAccountData() {
        
        //MARK: - Delete Messages
        
        Task {
            for room in rooms {
                db.collection(room.id ?? "").whereField("senderID", isEqualTo: currentUser?.id ?? "").getDocuments() { (querySnapshot, err) in
                  if let err = err {
                    print("Error getting documents: \(err)")
                  } else {
                    for document in querySnapshot!.documents {
                      document.reference.delete()
                    }
                  }
                }
            }
            
            
            //MARK: - Remove Rooms
            for room in rooms {
                db.collection("rooms").document(room.id ?? "").updateData(["members" : Firebase.FieldValue.arrayRemove([currentUser?.id ?? ""])]){ err in
                    if let err = err {
                        print("Error in adding item: \(err)")
                    }
                }
            }
            

            //MARK: - Delete Local Notifications
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                for request in requests {
                    if request.content.title == "Freshness Check" {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    }
                }
            }
            
            do {
                DispatchQueue.main.async {
                    self.clearUserInfoAfterDelete()
                }
                
                try await Auth.auth().currentUser?.delete()
                
                
            }
            catch {
                print("Something Caught")
            }
     
            
            
        }
        
    }// END DELETE ACCOUNT FUNCTION
    

    func clearUserInfoAfterDelete() {
        Task {@MainActor in
            let userID = currentUser?.id ?? ""
            try await db.collection("users").document(userID).delete()
            userSession = nil
            didAuthenticateUser = false
        }
    }

//MARK: - END

}
