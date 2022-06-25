//
//  RoomJoinRequest.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/24/22.
//

import Foundation

struct RoomRequest: Codable, Hashable {
    var message: String?
    var roomID: String
    var roomName: String
    var senderID: String
    var senderName: String?
    var receiverEmail: String
}
