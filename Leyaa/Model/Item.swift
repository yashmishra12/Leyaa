//
//  Item.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/19/22.
//

import Foundation

struct Item: Codable, Hashable {
    var name: String
    var desc: String
    var qty: String
    var assignedTo: String
}
