//
//  Message.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/28/22.
//

import Foundation

struct Message: Codable, Identifiable, Hashable {
    var id: String
    var text: String
    var senderID: String
    var timestamp: Date
}
