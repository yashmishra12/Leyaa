//
//  PendingReminder.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/12/22.
//

import Foundation

struct PendingReminder: Codable, Identifiable, Hashable {
    var id: String
    var body: String
    var subtitle: String
    var timestamp: String
}
