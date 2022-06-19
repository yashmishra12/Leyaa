//
//  RoomViewModel.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/16/22.
//
//
//import Foundation
//import Firebase
//
////struct Room: Codable, Identifiable {
////    var id: String
////    var title: String
////    var joinCode: String
////}
//
//class RoomViewModel: ObservableObject {
//    @Published var rooms = [Room]()
//
//    private let db = Firestore.firestore()
//    private let user = Auth.auth().currentUser
//
//    func fetchData() {
//        if (user != nil) {
//            db.collection("rooms").whereField("users", arrayContains: user!.uid).addSnapshotListener { snapshot, error in
//                guard let documents = snapshot?.documents else {
//                    print ("No Doc Found")
//                    return
//                }
//
//                self.rooms = documents.map({docSnapshot -> Room in
//                    let data = docSnapshot.data()
//                    let docId = docSnapshot.documentID
//                    let title = data["title"] as? String ?? ""
//                    let joinCode = data["joinCode"] as? String ?? "-1"
//                    return Room(id: docId, title: title, joinCode: joinCode)
//                })
//            }
//        }
//    }
//
//    func sendMessage(messageContent: String, docId: String) {
//        if (user != nil) {
//            db.collection("chatrooms").document(docId).collection("messages").addDocument(data: ["sentAt": Date(),
//                                                                                                 "displayName":
//                                                                                                    "John Doe",
//                                                                                                 "content": messageContent,
//                                                                                                 "sender": user!.uid])
//        }
//    }
//}
