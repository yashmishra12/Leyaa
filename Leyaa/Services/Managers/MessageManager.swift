//
//  MessageManager.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/28/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI


class MessageManager: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published var roomID: String
    @Published private(set) var lastMessageID = ""
    
    let db = Firestore.firestore()
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    init(name: String? = nil) {
        if let name = name {
            roomID = name
        } else {
            roomID = ""
        }
    }
    
    func updateRoomID(name: String) {
        roomID = name
    }

    //MARK: - Get Message
    func getMessages (roomID rid: String? ) {
        
        self.db.collection(rid ?? roomID)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    
                    guard let doc = snapshot?.documents else {
                        print("No Doc Found - get Messages")
                        return
                    }
                    
                    self.messages = doc.compactMap { queryDocumentSnapshot -> Message? in
                        
                        let result = Result { try queryDocumentSnapshot.data(as: Message.self) }
                        
                        switch result {
                        case .success(let msg):
                            return msg
                            
                        case .failure( _):
                            print("Failure Room Populate Messenger")
                            return nil
                        }
                    }
                    
                    self.messages.sort { $0.timestamp < $1.timestamp }
                    
                    if let id = self.messages.last?.id {
                        self.lastMessageID = id
                    }
                }
            }
    }
    
    //MARK: - Send Message
    func sendMessage (text: String, senderID: String) {
        do {
            let messageID = db.collection(self.roomID).document().documentID
            let newMessage = Message(id: messageID, text: text, senderID: senderID, timestamp: Date())
            
            try db.collection(self.roomID).document(messageID).setData(from: newMessage)
            
            
            if let id = self.messages.last?.id {
                self.lastMessageID = id
            }
        } catch {
            print("Error writing message in FireStore: \(error)")
        }
    }
    
    //MARK: - Messages
    
    func deleteMessage(room: String, messageID: String) {
        self.db.collection(room).document(messageID).delete() { err in
            if let err = err {
                print("Error in Deleting message: \(err)")
            }
        }
        
        hapticFeedback.notificationOccurred(.success)
    }
    
}
