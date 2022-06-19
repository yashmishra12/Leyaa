//
//  Room.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/18/22.
//

import Foundation

struct Room: Codable, Identifiable {
    var id: String
    var title: String
    var newIetms: [String]
    var oldItems: [String]
    var members: [String]
}
