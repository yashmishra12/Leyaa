//
//  RoomJoinRequest.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/24/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct RoomRequest: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var message: String?
    var roomID: String
    var roomName: String
    var senderName: String
    var receiverEmail: String
}
