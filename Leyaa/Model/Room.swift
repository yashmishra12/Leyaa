//
//  Room.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Room: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var title: String
    var newItems: [Item]
    var members: [String]
}

