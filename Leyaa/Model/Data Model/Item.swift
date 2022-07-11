//
//  Item.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/19/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Item: Codable, Hashable, Identifiable {
    
    var id: String = UUID().uuidString
    var name: String
    var desc: String
    var qty: String
}
