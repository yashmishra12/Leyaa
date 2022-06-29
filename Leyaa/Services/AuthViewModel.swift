//
//  AuthViewModel.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/15/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser: Bool = false
    @Published var rooms = [Room]()
    @Published var pendingReqest = [RoomRequest]()
    @Published var currentUser: User?
    
    private var db = Firestore.firestore()
    
    private let service = UserService()
    
    init(){
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
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
    func register(withEmail email: String, password: String, fullname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            
            let data = ["email": email,
                        "avatar": assetName.randomElement() ?? "egg",
                        "fullname": fullname,
                        "uid": user.uid] as [String : Any]
            
            
            self.db.collection("users").document(user.uid).setData(data) { _ in
                self.didAuthenticateUser = true
            }
            
        }
    }
    
    
    
    //MARK: - LOGOUT
    func signOut() {
        // sets user session to nil so we show login view
        userSession = nil
        didAuthenticateUser = false
        rooms = []
        
        // signs user out on server
        try? Auth.auth().signOut()
    }
    
    
    
    //MARK: - Fetch User
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
    
    //MARK: - Add Room
    
    func addRoom(room: Room) {
        do {
            let _ = try db.collection("rooms").addDocument(from: room)
        }
        catch {
            print(error)
        }
    }
    
    //MARK: - Add Item
    
    func addItem(item: [String : String], roomID: String ){
        
        db.collection("rooms").document(roomID).updateData(
            ["newItems" : Firebase.FieldValue.arrayUnion([item])]
        ){ err in
            if let err = err {
                print("Error in adding item: \(err)")
            }
        }
    }
    
    //MARK: - Delete Item
    
    func deleteItem(del: Item, roomID: String) {
        let itemDel: [String: String] = [
            "id": del.id,
            "name": del.name,
            "desc": del.desc,
            "qty": del.qty
        ]
        
        
        
        let docRef = db.collection("rooms").document(roomID)
        
        DispatchQueue.main.async {
            docRef.updateData([
                "newItems" : FieldValue.arrayRemove([itemDel]) ]){ err in
                    if let err = err {
                        print("Error in delete item: \(err)")
                    }
                }
        }
    }
    
    
    //MARK: - Poppulate Room List
    func populateRoomList () {
        
        self.db.collection("rooms")
            .whereField("members", arrayContains: self.userSession?.uid as Any)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    
                    guard let doc = snapshot?.documents else {
                        print("No Doc Found")
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
    }
    
    //MARK: - Leave Room
    
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
    
    
    
    //MARK: - Room Join Request
    func roomJoinRequestUpdate() {
        self.db.collection("roomRequest")
            .whereField("receiverEmail", isEqualTo: self.userSession?.email as Any)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    
                    guard let doc = snapshot?.documents else {
                        print("No Doc Found")
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
    
    
    //MARK: - CRITICAL FUNCTION
    
    func criticalFunc() {
        populateRoomList()
        roomJoinRequestUpdate()
    }
    
    //MARK: - Room Invite
    
    func roomInvite(recieverEmail: String, message: String, roomData: Room) {
        
        let req = RoomRequest(message: message, roomID: roomData.id ?? "", roomName: roomData.title , senderName: currentUser?.fullname ?? "", receiverEmail: recieverEmail)
        
        
        do {
            let _ = try db.collection("roomRequest").addDocument(from: req)
        }
        catch {
            print(error)
        }
        
        
    }
    
    
    //MARK: - Reject Room Request
    
    func rejectRoomRequest(reqData: RoomRequest) {
        
        self.db.collection("roomRequest").document(reqData.id ?? "").delete() { err in
            if let err = err {
                print("Error in adding item: \(err)")
            }
        }
    }
    
    //MARK: - Accept Room Request
    func acceptRoomRequest(reqData: RoomRequest) {
        let userToAdd: [String] = [currentUser?.id ?? ""]
        self.db.collection("rooms").document(reqData.roomID)
            .updateData(["members" : Firebase.FieldValue.arrayUnion(userToAdd)]){ err in
                if let err = err {
                    print("Error in adding item: \(err)")
                }
            }
        
        rejectRoomRequest(reqData: reqData)
    }
    
    //MARK: - Edit Item
    
    func editItem(item: Item, name: String, qty: String, desc: String, roomID: String) {
        
        let itemDel: [String: String] = [
            "id": item.id,
            "name": item.name,
            "desc": item.desc,
            "qty": item.qty
        ]
        
        let itemUpdate: [String: String] = [
            "id": UUID().uuidString,
            "name": name,
            "desc": desc,
            "qty": qty
        ]
        
        let docRef = db.collection("rooms").document(roomID)
        
        docRef.updateData(["newItems" : Firebase.FieldValue.arrayRemove([itemDel])]){ err in
            if let err = err {
                print("Error in delete item with EDIT: \(err)")
            }
        }
        
        docRef.updateData(["newItems" : Firebase.FieldValue.arrayUnion([itemUpdate])]){ err in
            if let err = err {
                print("Error in ADDING item with EDIT: \(err)")
            }
        }
        
        
        
    }
    
    
    //MARK: - Get Profile Avatar
    func getProfileAvatar(userID: String, completion: @escaping (String) -> Void) {
        var profilePic: String = ""
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                profilePic = document.get("avatar") as! String
                completion(profilePic)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    
    //MARK: - Get Profile Name
    func getProfileName(userID: String, completion: @escaping (String) -> Void) {
        var profileName: String = ""
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                profileName = document.get("fullname") as! String
                completion(profileName)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //MARK: - Email
    func getProfileEmail(userID: String, completion: @escaping (String) -> Void) {
        var profileEmail: String = ""
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                profileEmail = document.get("email") as! String
                completion(profileEmail)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //MARK: - AVATAR
    func getAvatar(userID: String, completion: @escaping (String) -> Void) {
        var profileAvatar: String = ""
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                profileAvatar = document.get("email") as! String
                completion(profileAvatar)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //MARK: - Update Avatar
    func updateAvatar(userID: String, newAvatar: String) {
        db.collection("users").document(userID).setData([
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
    
    
}
